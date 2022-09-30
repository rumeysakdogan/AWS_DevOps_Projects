#! /bin/bash
yum update -y
hostnamectl set-hostname petclinic-dev-server
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
-o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
yum install git -y
yum install java-11-amazon-corretto -y
cd /home/ec2-user
su ec2-user -c "git clone https://github.com/clarusway/petclinic-microservices-with-db.git"
cd petclinic-microservices-with-db
su ec2-user -c "git fetch"
su ec2-user -c "git checkout dev"