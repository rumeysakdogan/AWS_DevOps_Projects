terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "amazon_linux_2" {
   most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.my_key
  vpc_security_group_ids = [aws_security_group.web_sec_grp.id]
  tags = {
    Name = var.name_tag
  }
  user_data = <<EOF
     #!/bin/bash
     yum update -y
     yum install httpd -y
     cd /var/www/html
     FOLDER="https://raw.githubusercontent.com/rumeysakdogan/AWS_DevOps_Projects/main/Project-101-Kittens-carousel-static-website-ec2/static-web"
     wget $FOLDER/index.html
     wget $FOLDER/cat0.jpg
     wget $FOLDER/cat1.jpg
     wget $FOLDER/cat2.jpg
     wget $FOLDER/cat3.png
     systemctl start httpd
     systemctl enable httpd
     EOF
}

resource "aws_security_group" "web_sec_grp" {
  tags = {
    Name = var.web_sec_grp
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_server_url" {
  value = "http://${aws_instance.web_server.public_dns}"
}