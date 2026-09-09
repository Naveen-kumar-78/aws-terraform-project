terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "practice-vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "practice-vpc"
  }
}

resource "aws_subnet" "practice-subnet-1" {
  vpc_id = aws_vpc.practice-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "practice-subnet-1"
  }
}

resource "aws_subnet" "practice-subnet-2" {
  vpc_id = aws_vpc.practice-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "practice-subnet-2"
  }
}


resource "aws_internet_gateway" "practice-igw" {
  vpc_id = aws_vpc.practice-vpc.id

  tags = {
    Name = "practice-igw"
  }
}

resource "aws_route_table" "practice-route-table" {
  vpc_id = aws_vpc.practice-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.practice-igw.id
  }
  
  

  tags = {
    Name = "practice-route-table"
  }

}

resource "aws_route_table_association" "practice-rtb" {
  subnet_id      = aws_subnet.practice-subnet-1.id
  route_table_id = aws_route_table.practice-route-table.id
}

resource "aws_route_table_association" "practice-rtb" {
  subnet_id      = aws_subnet.practice-subnet-2.id
  route_table_id = aws_route_table.practice-route-table.id
}