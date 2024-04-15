#! /bin/bash
hostnamectl set-hostname docker_instance
yum update -y
yum install git -y
yum install docker -y
systemctl start docker
systemctl enable docker
TOKEN=${user-data-git-token}
USER=${user-data-git-name}
usermod -a -G docker ec2-user
newgrp docker
#install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd /home/ec2-user && git clone https://$TOKEN@github.com/$USER/bookstore-app.git
cd bookstore-app
docker-compose up
