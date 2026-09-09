# AWS Enterprise Terraform Infrastructure

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D%201.0-blue.svg)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS-v5.0-orange.svg)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A modular, enterprise-grade Infrastructure as Code (IaC) setup built with **HashiCorp Terraform** for AWS cloud resources. Incorporating remote state management with **AWS S3 native state locking**, zero static credentials via **AWS SSO**, dynamic secret injection via **HashiCorp Vault**, and environment isolation.

---

## 🏗️ Repository Architecture

```text
aws-terraform-project/
├── README.md                  # Project overview & deployment quickstart (this file)
├── ARCHITECTURE.md            # Detailed system architecture document
├── global/
│   └── s3-backend/            # S3 Remote State Bucket (with native S3 state locking)
├── environments/
│   ├── prod/                  # Production Environment Root (10.2.0.0/16)
│   └── test/                  # Test Environment Root (10.1.0.0/16)
└── modules/                   # Reusable Building Block Modules
    ├── vpc/                   # VPC, Subnet & Route Table module
    ├── security_group/        # Security Group dynamic rules module
    └── ec2/                   # EC2 Instance & EBS Attachment module
```

---

## 🔐 Key Security & Architectural Principles

1. **Remote State & Concurrency Locking:** State files are stored remotely in an **encrypted AWS S3 bucket (AES256)** with object versioning enabled. Concurrency locking is handled natively via **Amazon S3 (`use_lockfile = true`)** without needing DynamoDB.
2. **Environment Isolation:** Complete separation between `prod` and `test` environments via distinct state file keys and isolated VPC IP spaces (`10.2.0.0/16` for Prod vs `10.1.0.0/16` for Test).
3. **Zero Static Credentials:** Developers authenticate locally via **AWS SSO** (`aws sso login`). Production deployment pipelines execute via **GitHub Actions & HashiCorp Vault OIDC** short-lived tokens.
4. **Decoupled Parameters:** Infrastructure logic (`main.tf`) is decoupled from environment runtime variables (`terraform.tfvars`).

---

## 🏢 Enterprise Scalability & Multi-Team Governance

This architecture follows the battle-tested patterns used by enterprise DevOps and Platform Engineering teams to scale production systems and maintain operational excellence across large teams:

### 1. Strict Blast-Radius Containment & Isolation
* **Independent State Files**: Each environment (`test`, `prod`) maintains its own isolated S3 state key. Modifying test infrastructure can **never** inadvertently corrupt or modify production resources.
* **Non-Overlapping Network Topologies**: Each environment operates inside isolated VPC CIDR blocks (`10.1.0.0/16` for test vs `10.2.0.0/16` for prod), preventing IP space conflicts and accidental cross-talk.

### 2. Multi-Engineer Team Collaboration Without Collisions
* **Native S3 Concurrency Locking (`use_lockfile = true`)**: When an engineer or CI/CD runner executes `terraform apply`, Terraform automatically acquires an atomic lock directly in Amazon S3, preventing simultaneous conflicting deployments.
* **Centralized Modules, Decentralized Consumption**: Platform engineers build and harden standardized modules ([modules/vpc](file:///d:/aws-terraform-project/modules/vpc), [modules/ec2](file:///d:/aws-terraform-project/modules/ec2), [modules/security_group](file:///d:/aws-terraform-project/modules/security_group)). Application teams consume them across multiple projects without re-inventing security guardrails.

### 3. Effortless Scaling from Test to Enterprise Production
* **Code Reusability (DRY)**: Infrastructure module code remains identical across all tiers. Transitioning from test to enterprise production requires **zero code rewrites**—only parameter adjustments in `terraform.tfvars`:
  * **Compute Scaling**: Seamlessly scale instance sizes (`t3.micro` in test vs `m6i.xlarge` or compute clusters in prod).
  * **High Availability (HA)**: Expand from dual-AZ (`2` subnets in test) to multi-AZ fault tolerance (`3+` availability zones in prod).
  * **Storage Performance**: Scale EBS volumes and IOPS tiers independently without downtime.
* **Rapid Environment Provisioning**: Creating a new environment (such as `staging`, `qa`, or a disaster-recovery `prod-dr`) takes minutes—simply add a new folder under `environments/` and supply a `terraform.tfvars`.

### 4. Enterprise CI/CD Lifecycle & Governance
```mermaid
graph LR
    Dev["Developer Branch"] -->|"PR (terraform plan)"| GitHub["GitHub Pull Request"]
    GitHub -->|"Peer Review & Lint Checks"| Approval["Team Lead Approval"]
    Approval -->|"Merge to main"| Runner["CI/CD Runner (Vault OIDC)"]
    Runner -->|"terraform apply"| AWSProd["AWS Production (ap-south-1)"]
```
* **Auditability & Compliance**: Every infrastructure change is recorded via Git commit history and S3 state object versioning, providing instant rollbacks and compliance auditing (SOC2, ISO 27001).
* **Zero Long-Lived Secrets**: No static AWS access keys exist on developer machines. Authentication is powered by **AWS SSO** and **HashiCorp Vault / GitHub OIDC short-lived tokens**.

---

## 🛠️ Prerequisites & Local Setup

### 1. Tools Required
* [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (`>= 1.0`)
* [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Git](https://git-scm.com/)

### 2. AWS SSO Authentication
Log in using your temporary AWS SSO developer session:
```bash
aws sso login --profile dev-profile
export AWS_PROFILE=dev-profile
```

---

## 🚀 Deployment Quickstart

### Step 1: Bootstrap S3 Remote State (One-Time Setup)
```bash
cd global/s3-backend
terraform init
terraform plan
terraform apply
```

### Step 2: Deploy to Test Environment
```bash
cd ../../environments/test
terraform init
terraform plan
```

### Step 3: Deploy to Production Environment
```bash
cd ../../environments/prod
terraform init
terraform plan
```

> **Note:** Developers use `terraform plan` locally for dry-run validation. Production `terraform apply` is executed automatically via GitHub Actions upon merging an approved PR to `main`.

---

## 📄 Documentation Links

For detailed architectural topologies and module contract specifications:
* [System Architecture Overview](file:///d:/aws-terraform-project/ARCHITECTURE.md)
* [Production Environment Architecture](file:///d:/aws-terraform-project/environments/prod/ARCHITECTURE.md)
* [Test Environment Architecture](file:///d:/aws-terraform-project/environments/test/ARCHITECTURE.md)
* [Reusable Module Contracts](file:///d:/aws-terraform-project/modules/ARCHITECTURE.md)

---

## 🤝 Contribution & Git Workflow

1. Create a feature branch: `git checkout -b feature/my-new-feature`
2. Format & validate code: `terraform fmt -check` && `terraform validate`
3. Dry-run locally: `terraform plan`
4. Push & open a Pull Request (PR) against `main`.
