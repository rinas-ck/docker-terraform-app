provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "docker_server" {
  ami           = "ami-0f5ee92e2d63afc18" # Ubuntu
  instance_type = "t2.micro"
  key_name      = "mykey"

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
