terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "tf-rancher-server" {
  ami           = var.myami
  instance_type = var.instancetype
  key_name      = var.mykey
  vpc_security_group_ids = [aws_security_group.tf-rancher-sec-gr.id]
  iam_instance_profile = aws_iam_instance_profile.profile_for_rancher.name
  subnet_id = var.rancher-subnet
  root_block_device {
    volume_size = 16
  }
  user_data = file("rancherdata.sh")
  tags = {
    Name = var.tags
    "kubernetes.io/cluster/petclinic-Rancher" = "owned"
  }
}

resource "aws_alb_target_group" "rancher-tg" {
  name = "clarus-rancher-http-80-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "vpc-f52d178f"
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path = "/healthz"
    port = "traffic-port"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5
    interval = 10
  }
}

resource "aws_alb_target_group_attachment" "rancher-attach" {
  target_group_arn = aws_alb_target_group.rancher-tg.arn
  target_id = aws_instance.tf-rancher-server.id
}

data "aws_vpc" "selected" {
  default = true
}

resource "aws_lb" "rancher-alb" {
  name = "petclinic-rancher-alb"
  ip_address_type = "ipv4"
  internal = false
  load_balancer_type = "application"
  subnets = ["subnet-c41ba589", "subnet-3ccd235a", "subnet-077c9758"]
  security_groups = [aws_security_group.rancher-alb.id]
}

data "aws_acm_certificate" "cert" {
  domain = var.domain-name
  statuses = [ "ISSUED" ]
  most_recent = true
}

resource "aws_alb_listener" "rancher-listener1" {
  load_balancer_arn = aws_lb.rancher-alb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.cert.arn
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.rancher-tg.arn
  }
}
resource "aws_alb_listener" "rancher-listener2" {
  load_balancer_arn = aws_lb.rancher-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
    }
}
resource "aws_iam_policy" "policy_for_rke-controlplane_role" {
  name        = "petclinic_policy_for_rke-controlplane_role"
  policy      = file("cw-rke-controlplane-policy.json")
}

resource "aws_iam_policy" "policy_for_rke_etcd_worker_role" {
  name        = "petclinic_policy_for_rke_etcd_worker_role"
  policy      = file("cw-rke-etcd-worker-policy.json")
}

resource "aws_iam_role" "role_for_rancher" {
  name = "petclinic_role_rancher"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "petclinic_role_controlplane_rke"
  }
}

resource "aws_iam_policy_attachment" "attach_for_rancher1" {
  name       = "petclinic_attachment_for_rancher_controlplane"
  roles      = [aws_iam_role.role_for_rancher.name]
  policy_arn = aws_iam_policy.policy_for_rke-controlplane_role.arn
}

resource "aws_iam_policy_attachment" "attach_for_rancher2" {
  name       = "petclinic_attachment_for_rancher_worker"
  roles      = [aws_iam_role.role_for_rancher.name]
  policy_arn = aws_iam_policy.policy_for_rke_etcd_worker_role.arn
}

resource "aws_iam_instance_profile" "profile_for_rancher" {
  name  = "profile_for_petclinic_rancher"
  role = aws_iam_role.role_for_rancher.name
}


data "aws_route53_zone" "dns" {
  name = var.hostedzone  
}

resource "aws_route53_record" "arecord" {
  name = "rancher.${data.aws_route53_zone.dns.name}"
  type = "A"
  zone_id = data.aws_route53_zone.dns.zone_id
  alias {
    name = aws_lb.rancher-alb.dns_name
    zone_id = aws_lb.rancher-alb.zone_id
    evaluate_target_health = true
  }

}