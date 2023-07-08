# Terraform Infrastructure Provisioning

This directory [infrastructure-terraform](https://github.com/Keicee32/Altschool-Capstone-Project/blob/Infrastructure/infrastructure-terraform) contains Terraform configurations to provision project's infrastructure using AWS as the cloud provider.

## Prerequisites

Before you begin, ensure that you have the following prerequisites:

- Terraform CLI installed ([Download Terraform](https://www.terraform.io/downloads.html))
- AWS account with appropriate credentials

## Configuration

### Provider Configuration (000-provider.tf)

The [000-providers.tf](000-providers.tf) file specifies the S3 bucket, AWS provider and its configuration. Make sure to set your AWS access and secret keys as environment variables or use other appropriate methods for authentication.

```hcl
provider "aws" {
  region = "var.region"
}
```
### Variable Declarations (variable.tf)
The variable.tf file declares the variables used in the Terraform configuration. Modify the default values or specify them using a terraform.tfvars file.

```hcl
variable "region" {}
variable "project_name" {}
variable "vpc_cidr_block" {}
variable "public_subnet_cidr_blocks" {}
variable "private_subnet_cidr_blocks" {}
variable "ami_type" {}
variable "instance_type" {}
variable "cluster_name" {}
variable "cluster_version" {}
variable "domain_name" {}
variable "token" {}
variable "username" {} 
}
```
### Terraform Variables (terraform.tfvars)
The terraform.tfvars file is used to provide specific values for the variables defined in variable.tf.
```hcl
project_name               = " "
region                     = " "
vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_blocks  = ["10.0.2.0/24", "10.0.6.0/24", "10.0.10.0/24"]
private_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.8.0/24", "10.0.12.0/24"]
ami_type                   = " "
instance_type              = "t3.medium"
cluster_name               = " "
cluster_version            = " "
domain_name                = " "
```


## Usage

1. Clone the repository to your local machine.

```bash
git clone https://github.com/Keicee32/Altschool-Capstone-Project.git
```

2. Change into the project directory.

```bash
cd Altschool-Capstone-Project
```

3. Configure the AWS CLI with your IAM credentials.

```bash
aws configure
```
### Provisioning the Infrastructure

1. Initialize the Terraform configuration:

```bash
terraform init 
```

2. Plan the infrastructure changes:
```bash
terraform plan
```
3. Apply the infrastructure changes:
```bash
terraform apply
```
Enter 'yes' when prompted to confirm the changes.

## Clean Up

To destroy the provisioned infrastructure and clean up all resources, run the following command:
```bash
terraform destroy
```
Enter yes when prompted to confirm the destruction.

Make sure to review the execution plan before confirming the destruction.

Note: Destroying the infrastructure will permanently delete all associated resources.