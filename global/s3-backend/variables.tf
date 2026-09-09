variable "aws_region" {
  description = "AWS region to deploy backend resources"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state (leave empty for auto-generated name)"
  type        = string
  default     = ""
}
