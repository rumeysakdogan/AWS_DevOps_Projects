terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.28.0"
    }
  }
}

provider "github" {
  # Configuration options
  token = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "github_repository" "bookstore-repo" {
  name       = "bookstore-repo"
  auto_init  = true
  visibility = "private"
}

resource "github_branch_default" "main" {
  branch     = "main"
  repository = github_repository.bookstore-repo.name
}

variable "files" {
  default = ["bookstore-api.py", "Dockerfile", "docker-compose.yml", "requirements.txt"]
}

resource "github_repository_file" "app-files" {
  for_each            = toset(var.files)
  content             = file(each.value)
  file                = each.value
  repository          = github_repository.bookstore-repo.name
  branch              = "main"
  commit_message      = "managed by Terraform"
  overwrite_on_create = true
}

resource "aws_instance" "tf-docker" {
  ami             = "ami-090fa75af13c156b4"
  instance_type   = "t2.micro"
  key_name        = "FirstKey"
  security_groups = ["docker-sg-203"]
   tags = {
    Name = "Web Server of Rumeysa's Bookstore"
  }
  user_data  = <<-EOF
    #! /bin/bash
    yum update -y
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user
    curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    mkdir -p /home/ec2-user/bookstore-api
    TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    FOLDER="https://$TOKEN@raw.githubusercontent.com/rumeysakdogan/bookstore-repo/main/"
    curl -s -o "/home/ec2-user/bookstore-api/bookstore-api.py" -L "$FOLDER"bookstore-api.py
    curl -s -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
    curl -s -o "/home/ec2-user/bookstore-api/docker-compose.yml" -L "$FOLDER"docker-compose.yml
    curl -s -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
    cd /home/ec2-user/bookstore-api
    docker build -t bookstoreapi:latest .
    docker-compose up -d
    EOF

  depends_on = [github_repository.bookstore-repo, github_repository_file.app-files]

}

resource "aws_security_group" "tf-docker-ec2-sg" {

  name = "docker-sg-203"
  tags = {
    Name = "docker-sg-203"
  }

   ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}


output "website" {
  value = "http://${aws_instance.tf-docker.public_dns}"

}