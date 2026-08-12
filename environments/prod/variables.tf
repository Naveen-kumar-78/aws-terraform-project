variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
}

variable "create_additional_volume" {
  description = "Whether to create and attach an additional EBS volume"
  type        = bool
}

variable "additional_volume_size" {
  description = "Size of the additional EBS volume in GB"
  type        = number
}

variable "additional_volume_type" {
  description = "Type of the additional EBS volume"
  type        = string
}

variable "ami_owner" {
  description = "AWS AMI owner account ID (e.g. 099720109477 for Canonical/Ubuntu, amazon for Amazon Linux)"
  type        = string
}

variable "ami_name_filter" {
  description = "AWS AMI name search filter string"
  type        = string
}

