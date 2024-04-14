# Please change the key_name and your config file 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region  = "us-east-1"
}

resource "aws_security_group" "ec2-secgr" {
  name = "app-sec-aws_security_group"
  description = "Allow ssh inbound traffic"


dynamic "ingress" {
    for_each = [22,80,8080,3306]
    content {
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]    
    }
}

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "ec2" {
   ami = data.aws_ami.amazon-linux-2.id
   instance_type = "t2.micro"
   key_name = "firstkey"
   vpc_security_group_ids = [aws_security_group.ec2-secgr.id]
   tags = {
    Name = "Web Server of Bookstore"
   }
   user_data = templatefile ("userdata.sh", {user-data-git-token = var.token , user-data-git-name = var.user})
}

variable "token" {
  default = "xxx"
}
 variable "user" {
   default = "JayyyJayyyyy"
 }
