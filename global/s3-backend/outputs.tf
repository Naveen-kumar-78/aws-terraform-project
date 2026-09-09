output "s3_bucket_name" {
  description = "The S3 Bucket name created for remote state storage"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 Bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "prod_backend_config_snippet" {
  description = "Backend block to copy into environments/prod/main.tf"
  value       = <<EOT
  backend "s3" {
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    key          = "environments/prod/terraform.tfstate"
    region       = "${var.aws_region}"
    use_lockfile = true
    encrypt      = true
  }
EOT
}

output "test_backend_config_snippet" {
  description = "Backend block to copy into environments/test/main.tf"
  value       = <<EOT
  backend "s3" {
    bucket       = "${aws_s3_bucket.terraform_state.id}"
    key          = "environments/test/terraform.tfstate"
    region       = "${var.aws_region}"
    use_lockfile = true
    encrypt      = true
  }
EOT
}
