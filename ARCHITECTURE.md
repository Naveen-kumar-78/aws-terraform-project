# AWS Terraform Infrastructure Architecture

## Overview
This repository contains a modular, clean, and scalable Infrastructure as Code (IaC) setup built with **HashiCorp Terraform** for AWS cloud resources.

The codebase is structured into reusable resource modules (`modules/`) and environment root configurations (`environments/prod`, `environments/test`), enforcing strict isolation, parameter decoupling via `.tfvars`, and DRY practices.

---

## Directory Structure

```
aws-terraform-project/
├── ARCHITECTURE.md                  # High-level architecture overview (this file)
├── environments/
│   ├── prod/                        # Production Environment Root
│   │   ├── main.tf                  # Module orchestration
│   │   ├── variables.tf             # Variable declarations & schema
│   │   ├── outputs.tf               # Environment output specifications
│   │   ├── terraform.tfvars         # Production variable values (Decoupled configuration)
│   │   ├── terraform.tfvars.example # Production sample configuration
│   │   └── ARCHITECTURE.md          # Production architecture details & diagram
│   └── test/                        # Test Environment Root
│       ├── main.tf                  # Module orchestration
│       ├── variables.tf             # Variable declarations & schema
│       ├── outputs.tf               # Environment output specifications
│       ├── terraform.tfvars         # Test variable values (Decoupled configuration)
│       ├── terraform.tfvars.example # Test sample configuration
│       └── ARCHITECTURE.md          # Test architecture details & diagram
└── modules/                         # Reusable Terraform Modules
    ├── ARCHITECTURE.md              # Reusable module contracts & architecture
    ├── vpc/                         # VPC, Subnets & Routing module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security_group/              # Security Group module (Dynamic rules)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2/                         # EC2 Compute & EBS attachment module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Key Design Principles

1. **Environment Isolation**: `prod` and `test` environments run independently with distinct state files and IP spaces (`10.2.0.0/16` for prod vs `10.1.0.0/16` for test).
2. **Decoupled Configuration via `.tfvars`**: Infrastructure code (`main.tf`) and schema (`variables.tf`) are completely separated from runtime parameters (`terraform.tfvars`).
3. **Modular Composition**: Standardized building blocks (`vpc`, `security_group`, `ec2`) ensure consistency across all deployments.
4. **Least Privilege & Defensive Design**: Production disables SSH ingress from `0.0.0.0/0`, while Test limits SSH for development.
5. **Self-Documenting Architecture**: Every component level (`prod`, `test`, `modules`, and root) contains dedicated `ARCHITECTURE.md` documentation with visual Mermaid diagrams.

---

## Deployment Quickstart

### Working with `prod` Environment
```bash
cd environments/prod
terraform init
terraform plan
terraform apply
```

### Working with `test` Environment
```bash
cd environments/test
terraform init
terraform plan
terraform apply
```

Refer to the individual `ARCHITECTURE.md` files in each subfolder for detailed network topologies and configuration specs:
* [Production Architecture](file:///d:/aws-terraform-project/environments/prod/ARCHITECTURE.md)
* [Test Architecture](file:///d:/aws-terraform-project/environments/test/ARCHITECTURE.md)
* [Module Architecture](file:///d:/aws-terraform-project/modules/ARCHITECTURE.md)
