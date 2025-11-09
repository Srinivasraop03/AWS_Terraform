provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "foo" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 22.04 LTS in us-east-1
  instance_type = "t3.micro"

  tags = {
    Name = "TF-Instance"
  }
}
