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

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc1"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "igw1"
  }
}
resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "publicsubnet1"
  }
}
resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "publicrt1"
  }
}
resource "aws_route_table_association" "myrtasscoiation" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.publicrt.id
}
resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "privatesubnet1"
  }
}
resource "aws_eip" "eip" {
  vpc      = true
}
resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.publicsubnet.id

  tags = {
    Name = "gw NAT"
  }
}
resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynat.id

}
  tags = {
    Name = "privatert1"
  }
}
resource "aws_route_table_association" "routetableassociation1" {
  subnet_id      = aws_subnet.privatesubnet.id
  route_table_id = aws_route_table.privatert.id
}
