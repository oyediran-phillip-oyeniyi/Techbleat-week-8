terraform {
  
  backend "s3" {
    bucket = "phil-terraform-state-bucket"
    key = "env/dev/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }

  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "default" {
  default = true
}

#-------------------------------------
# Web Node Security Group
#-------------------------------------

resource "aws_security_group" "nginx-sg" {
  name = "nginx-sg"
  description = "Allow SSH and Port 80 inbound, all outbound"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Nginx-security-group"
  }
}

resource "aws_instance" "nginx-node" {
  ami                    = var.nginx_ami
  instance_type          = var.instance_type
  subnet_id              = var.project_subnet
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "Nginx-node"
    Type = "Nginx"
  }
}


resource "aws_security_group" "python-sg" {
  name = "python-sg"
  description = "Allow SSH and Port 9000 inbound, all outbound"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Python-security-group"
  }
}


resource "aws_instance" "python-node" {
  ami                    = var.python_ami
  instance_type          = var.instance_type
  subnet_id              = var.project_subnet
  vpc_security_group_ids = [aws_security_group.python-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "Python-node"
    Type = "Python"
  }
}

resource "aws_security_group" "java-sg" {
  name = "java-sg"
  description = "Allow SSH and Port 8080 inbound, all outbound"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Java-security-group"
  }
}


resource "aws_instance" "java-node" {
  ami                    = var.java_ami
  instance_type          = var.instance_type
  subnet_id              = var.project_subnet
  vpc_security_group_ids = [aws_security_group.java-sg.id]
  key_name               = var.key_name

  tags = {
    Name = "Java-node"
    Type = "Java"
  }
}


output "nginx_instance_ip" {
  value       = aws_instance.nginx-node.public_ip
  description = "Public IP of Nginx instance"
}

output "python_instance_ip" {
  value       = aws_instance.python-node.public_ip
  description = "Public IP of Python instance"
}

output "java_instance_ip" {
  value       = aws_instance.java-node.public_ip
  description = "Public IP of Java instance"
}