# Terraform Reusable Modules Architecture

## Overview
The `modules/` directory contains highly reusable, DRY (Don't Repeat Yourself), environment-agnostic Terraform modules. These modules abstract complex AWS resource creation into predictable, configurable building blocks.

---

## Module Interaction & Dataflow Diagram

```mermaid
flowchart TD
    subgraph PROD_ENV ["Prod Environment (environments/prod)"]
        PROD_TFVARS["terraform.tfvars\ninstance_type = 't3.medium'\nroot_volume_size = 20\nvpc_cidr = '10.2.0.0/16'"]
        PROD_VARS["variables.tf\nDeclares schema & types"]
        PROD_MAIN["main.tf\nCalls modules & passes inputs"]
        
        PROD_TFVARS -->|Feeds values| PROD_VARS
        PROD_VARS -->|Passes to| PROD_MAIN
    end

    subgraph TEST_ENV ["Test Environment (environments/test)"]
        TEST_TFVARS["terraform.tfvars\ninstance_type = 't3.micro'\nroot_volume_size = 8\nvpc_cidr = '10.1.0.0/16'"]
        TEST_VARS["variables.tf\nDeclares schema & types"]
        TEST_MAIN["main.tf\nCalls modules & passes inputs"]
        
        TEST_TFVARS -->|Feeds values| TEST_VARS
        TEST_VARS -->|Passes to| TEST_MAIN
    end

    subgraph REUSABLE_MODULES ["Reusable Infrastructure Modules (modules/)"]
        subgraph VPC_MOD ["modules/vpc"]
            VPC_CONTRACT["variables.tf\n[REQUIRED Inputs]\nvpc_cidr, environment,\nsubnets, availability_zones"]
            VPC_RES["main.tf\nCreates aws_vpc & subnets"]
        end

        subgraph SG_MOD ["modules/security_group"]
            SG_CONTRACT["variables.tf\n[REQUIRED Inputs]\nvpc_id, environment,\ningress_rules"]
            SG_RES["main.tf\nCreates aws_security_group"]
        end

        subgraph EC2_MOD ["modules/ec2"]
            EC2_CONTRACT["variables.tf\n[REQUIRED Inputs]\ninstance_type, root_volume_size,\nami, subnet_id, sg_ids"]
            EC2_RES["main.tf\nCreates aws_instance & EBS"]
        end
    end

    subgraph AWS_PROD ["AWS Cloud: Production Infrastructure"]
        PROD_VPC_AWS["VPC: 10.2.0.0/16"]
        PROD_SG_AWS["Security Group (App: 80, 443)"]
        PROD_EC2_AWS["EC2: t3.medium + 20GB Root + 50GB EBS"]
    end

    subgraph AWS_TEST ["AWS Cloud: Test Infrastructure"]
        TEST_VPC_AWS["VPC: 10.1.0.0/16"]
        TEST_SG_AWS["Security Group (App: 22, 80)"]
        TEST_EC2_AWS["EC2: t3.micro + 8GB Root + 5GB EBS"]
    end

    PROD_MAIN -->|Passes Prod Inputs| VPC_CONTRACT
    PROD_MAIN -->|Passes Prod Inputs| SG_CONTRACT
    PROD_MAIN -->|Passes Prod Inputs| EC2_CONTRACT

    TEST_MAIN -->|Passes Test Inputs| VPC_CONTRACT
    TEST_MAIN -->|Passes Test Inputs| SG_CONTRACT
    TEST_MAIN -->|Passes Test Inputs| EC2_CONTRACT

    VPC_RES -->|Provisions| PROD_VPC_AWS
    SG_RES -->|Provisions| PROD_SG_AWS
    EC2_RES -->|Provisions| PROD_EC2_AWS

    VPC_RES -->|Provisions| TEST_VPC_AWS
    SG_RES -->|Provisions| TEST_SG_AWS
    EC2_RES -->|Provisions| TEST_EC2_AWS
```

---

## Detailed Module Contracts

### 1. `vpc` Module (`modules/vpc`)

#### Purpose
Configures custom Virtual Private Cloud infrastructure including Internet Gateways, variable public/private subnet counts across specified Availability Zones, and route tables.

#### Structure
* `main.tf`: VPC, IGW, public/private subnets with count loops, route tables & associations.
* `variables.tf`:
  * `environment`: Environment identifier tag (`string`, required)
  * `vpc_cidr`: Base CIDR block (`string`, required)
  * `public_subnet_cidrs`: List of public CIDRs (`list(string)`, required)
  * `private_subnet_cidrs`: List of private CIDRs (`list(string)`, required)
  * `availability_zones`: AZ alignment (`list(string)`, required)
  * `tags`: Map of additional resource tags (`map(string)`, optional)
* `outputs.tf`:
  * `vpc_id`: ID of the created VPC
  * `public_subnet_ids`: List of public subnet IDs
  * `private_subnet_ids`: List of private subnet IDs

---

### 2. `security_group` Module (`modules/security_group`)

#### Purpose
Generates modular AWS Security Groups with dynamic HCL block generation for ingress and egress rules.

#### Structure
* `main.tf`: `aws_security_group` with dynamic `ingress` and `egress` blocks.
* `variables.tf`:
  * `environment`: Environment identifier tag (`string`, required)
  * `name`: Security group naming prefix (`string`, required)
  * `description`: Purpose description (`string`, default: `"Managed by Terraform"`)
  * `vpc_id`: Associated VPC ID (`string`, required)
  * `ingress_rules`: List of rule maps (`list(object)`, optional)
  * `egress_rules`: List of rule maps (`list(object)`, optional)
* `outputs.tf`:
  * `security_group_id`: ID of the created Security Group

---

### 3. `ec2` Module (`modules/ec2`)

#### Purpose
Provisions EC2 compute instances with custom root volume configuration, optional secondary EBS volume creation, auto-attachment, and public IP mapping options.

#### Structure
* `main.tf`: `aws_instance`, optional `aws_ebs_volume`, and `aws_volume_attachment`.
* `variables.tf`:
  * `environment`: Environment tag (`string`, required)
  * `name`: Instance name tag (`string`, required)
  * `ami`: AMI ID (`string`, required)
  * `subnet_id`: Target subnet ID (`string`, required)
  * `security_group_ids`: List of SG IDs (`list(string)`, required)
  * `instance_type`: EC2 size (`string`, required - no default)
  * `root_volume_size`: Root volume size in GB (`number`, required - no default)
  * `root_volume_type`: Root disk type (`string`, default: `"gp3"`)
  * `create_additional_volume`: EBS toggle (`bool`, default: `false`)
  * `additional_volume_size`, `additional_volume_type`, `additional_volume_device_name`: EBS spec
* `outputs.tf`:
  * `instance_id`: ID of the EC2 instance
  * `public_ip`: Public IP address (if assigned)
  * `private_ip`: Internal IP address
  * `subnet_id`: Subnet ID where the EC2 instance is launched
  * `security_group_id`: Primary security group ID attached to the EC2 instance


