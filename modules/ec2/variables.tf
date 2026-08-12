variable "environment" {
  description = "The environment name"
  type        = string
}

variable "name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Key pair name to use for SSH"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "create_additional_volume" {
  description = "Whether to create and attach an additional EBS volume"
  type        = bool
  default     = false
}

variable "additional_volume_size" {
  description = "Size of the additional EBS volume in GB"
  type        = number
  default     = 10
}

variable "additional_volume_type" {
  description = "Type of the additional EBS volume"
  type        = string
  default     = "gp3"
}

variable "additional_volume_device_name" {
  description = "Device name for the additional volume attachment (e.g., /dev/sdf)"
  type        = string
  default     = "/dev/sdf"
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
