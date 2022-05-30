provider "aws" {}

resource "aws_instance" "Ubuntu-server" {
  ami           = "ami-015c25ad8763b2f11"
  instance_type = "t2.micro"
}
