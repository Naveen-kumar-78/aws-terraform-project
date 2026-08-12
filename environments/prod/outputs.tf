output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "web_server_public_ip" {
  description = "Public IP of the prod web server"
  value       = module.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP of the prod web server"
  value       = module.web_server.private_ip
}

output "web_server_instance_id" {
  description = "Instance ID of the prod web server"
  value       = module.web_server.instance_id
}

output "web_server_security_group_id" {
  description = "Security group ID of the prod web server"
  value       = module.web_server.security_group_id
}

output "web_server_subnet_id" {
  description = "Subnet ID of the prod web server"
  value       = module.web_server.subnet_id
}