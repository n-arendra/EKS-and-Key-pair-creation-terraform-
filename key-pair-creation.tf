 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
} 

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

#Generate .pem file
resource "tls_private_key" "rsa_4096" {
  algorithm   = "RSA"
  rsa_bits =  4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "us-east-2"
  public_key = tls_private_key.rsa_4096.public_key_openssh
  }

resource "local_file" "foo" {
  content = tls_private_key.rsa_4096.private_key_pem
  filename = "us-east-2"
}


resource "aws_instance" "instance-1" {
  ami           = "ami-0e820afa569e84cc1"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name = "Demo"
  }
}



