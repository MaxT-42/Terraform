#----------------------------------------------------------
# Terraform
# Use script

provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-03a71cec707bfc3d7"
  instance_type          = "t2.micro"
  key_name               = "MaxT-key-Frankfurt"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("path_to_script.sh")


  tags = {
    Name = "Web Server Build by Terraform"
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My First SecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SecurityGroup"
  }
}
