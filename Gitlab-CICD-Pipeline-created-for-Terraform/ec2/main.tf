# --- ec2/main.tf

resource "aws_launch_template" "asg_webserver" {
  name_prefix            = "webserver"
  image_id               = "ami-026b57f3c383c2eec"
  instance_type          = var.webserver_type
  vpc_security_group_ids = [var.web_sg]
  key_name               = var.key

  tags = {
    Name = "webserver"
  }
}

resource "aws_autoscaling_group" "asg_webserver" {
  name                = "asg_webserver"
  vpc_zone_identifier = tolist(var.pub_subnets)
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.asg_webserver.id
    version = "$Latest"
  }
}