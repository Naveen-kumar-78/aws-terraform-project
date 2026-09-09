terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "aws-terraform-project-remote-state-bucket"
    key          = "environments/test/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
    encrypt      = true
  }
}

# Test Environment Main Configuration
provider "aws" {
  region = var.aws_region
}

# Dynamic OS AMI data source specified via var.ami_owner and var.ami_name_filter
data "aws_ami" "os" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "app_security_group" {
  source = "../../modules/security_group"

  environment = var.environment
  name        = "app"
  description = "Security group for ${var.environment} application"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description = "Allow SSH from anywhere (Test only)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "web_server" {
  source = "../../modules/ec2"

  environment = var.environment
  name        = "web-server"
  ami         = data.aws_ami.os.id

  
  # Use the first public subnet for test
  subnet_id = module.vpc.public_subnet_ids[0]
  
  security_group_ids          = [module.app_security_group.security_group_id]
  associate_public_ip_address = true
  
  instance_type    = var.instance_type
  root_volume_size = var.root_volume_size
  root_volume_type = var.root_volume_type
  
  # Create a small extra volume for test
  create_additional_volume = var.create_additional_volume
  additional_volume_size   = var.additional_volume_size
  additional_volume_type   = var.additional_volume_type
}
