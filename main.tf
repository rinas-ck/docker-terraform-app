data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "docker_server" {
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  ami           = data.aws_ami.ubuntu.id

  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

sudo docker login -u ${var.docker_user} -p ${var.docker_pass}

sudo docker pull ${var.docker_user}/myapp:latest

sudo docker run -d -p 80:5000 ${var.docker_user}/myapp:latest
EOF

  tags = {
    Name = "Docker-Terraform-Server"
  }
}

variable "docker_user" {}
variable "docker_pass" {}
