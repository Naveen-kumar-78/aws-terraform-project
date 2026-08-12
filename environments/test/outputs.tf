output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "web_server_public_ip" {
  description = "Public IP of the test web server"
  value       = module.web_server.public_ip
}
