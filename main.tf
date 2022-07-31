terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_instance" "launch" {

  instance_type = "t2.micro"
  ami           = "ami-052efd3df9dad4825"
  key_name           = "terraform"


          tags   =  {
       Name     = "my_instance"

}
 }
