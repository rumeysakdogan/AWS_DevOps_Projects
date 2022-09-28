//This Terraform template prepares development environment for Petclinic Microservices Application.
//User needs to select appropriate key name when launching the template.

provider "aws" {
  region = var.region
  //  access_key = ""
  //  secret_key = ""
  //  If you have entered your credentials in AWS CLI before, you do not need to use these arguments.
}

resource "aws_launch_template" "PetclinicServerLT" {
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.mykey
  vpc_security_group_ids = [aws_security_group.dev-server-sg.id]
  user_data = filebase64("petclinicserver-userdata.sh")
}

resource "aws_instance" "PetclinicServer" {
  launch_template {
    id = aws_launch_template.PetclinicServerLT.id
    version = aws_launch_template.PetclinicServerLT.latest_version
  }
  tags = {
    Name = var.devservertag
  }
}

resource "aws_security_group" "dev-server-sg" {
  name = var.devops_server_secgr
  tags = {
    Name = var.devops_server_secgr
  }
  dynamic "ingress" {
    for_each = var.dev-server-ports
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

output "PetclinicServerDNSName" {
  value = aws_instance.PetclinicServer.public_dns
}