provider "aws" {
    region = "us-east-1"  
}

resource "aws_instance" "foo" {
  ami           = "ami-0ecb62995f68bb549" # us-west-1
  instance_type = "t3.micro"
  tags = {
      Name = "TF-Instance"
  }
}
