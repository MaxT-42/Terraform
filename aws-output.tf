# Terraform
# cread and atach elastic IP

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    Name = "Web Server IP"
  }
}

provider "aws" {
  region = "eu-central-1"
}


resource "aws_instance" "created_by_Terraform" {
  ami                    = "ami-03a71cec707bfc3d7"
  instance_type          = "t2.micro"
  key_name               = "MaxT-key-Frankfurt"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("data.tpl", {
    f_name = "Max",
    l_name = "T",
    object = ["school", "shop", "university", "office", "forest", "lake"]
  })


  tags = {
    Name = "Web Server Build by Terraform"
  }
}

lifecycle {
  create_before_destroy = true
}

resource "aws_security_group" "created_by_Terraform" {
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

output "my_web_site_ip" {
  description = "Elatic IP address assigned to our WebSite"
  value       = aws_eip.my_static_ip.public_ip
}

output "my_instance_id" {
  description = "InstanceID of our WebSite"
  value       = aws_instance.created_by_Terraform.id
}

output "my_instance_arn" {
  description = "InstanceARN of our WebSite"
  value       = aws_instance.created_by_Terraform.arn
}

output "my_sg_id" {
  description = "SecurityGroup of our WebSite"
  value       = aws_security_group.created_by_Terraform.id
}
