output "s3_bucket_name" {
  description = "The S3 Bucket name created for remote state storage"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 Bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "The DynamoDB Table name created for state locking"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "prod_backend_config_snippet" {
  description = "Backend block to copy into environments/prod/main.tf"
  value       = <<EOT
  backend "s3" {
    bucket         = "${aws_s3_bucket.terraform_state.id}"
    key            = "environments/prod/terraform.tfstate"
    region         = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
    encrypt        = true
  }
EOT
}

output "test_backend_config_snippet" {
  description = "Backend block to copy into environments/test/main.tf"
  value       = <<EOT
  backend "s3" {
    bucket         = "${aws_s3_bucket.terraform_state.id}"
    key            = "environments/test/terraform.tfstate"
    region         = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
    encrypt        = true
  }
EOT
}
