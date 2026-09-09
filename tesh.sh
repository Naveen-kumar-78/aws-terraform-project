#!/bin/bash


cd global/s3-backend
terraform init
terraform plan
terraform apply

cd environments/test
terraform init
terraform plan
terraform apply