output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "The private IP of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "subnet_id" {
  description = "The subnet ID where the EC2 instance is launched"
  value       = aws_instance.this.subnet_id
}

output "security_group_id" {
  description = "The primary security group ID attached to the EC2 instance"
  value       = tolist(aws_instance.this.vpc_security_group_ids)[0]
}


