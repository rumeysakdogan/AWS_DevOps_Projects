resource "aws_security_group" "rancher-alb" {
  name = "petclinicdt-rancher-alb-sec-gr"
  tags = {
    Name = "petclinicdt-rancher-alb-sec-gr"
    "kubernetes.io/cluster/petclinic-Rancher" = "owned"
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "tf-rancher-sec-gr" {
  name = var.secgrname
  tags = {
    Name = var.secgrname
    "kubernetes.io/cluster/petclinic-Rancher" = "owned"
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    security_groups = [aws_security_group.rancher-alb.id]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    protocol    = "tcp"
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    self = true
  }

  egress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["35.167.242.46/32", "52.33.59.17/32", "35.160.43.145/32"]
  }
  egress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 2376
    protocol    = "tcp"
    to_port     = 2376
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    self = true
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}