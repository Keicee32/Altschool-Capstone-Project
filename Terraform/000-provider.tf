#----------------------------------------------------
#              Providers and s3 Backend
#----------------------------------------------------

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.18.1"
    }

    # namedotcom = {
    #   source  = "lexfrei/namedotcom"
    #   version = "~>1.0"
    # }
  }

  backend "s3" {
    bucket         = "capstone-24"
    key            = "capstone-24/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "capstone-24_State_Lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {
    host                   = module.AltSchool-Exam-EKS.cluster_endpoint
    cluster_ca_certificate = base64decode(module.AltSchool-Exam-EKS.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.AltSchool-Exam-EKS.cluster_name]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  host                   = module.AltSchool-Exam-EKS.cluster_endpoint
  cluster_ca_certificate = base64decode(module.AltSchool-Exam-EKS.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.AltSchool-Exam-EKS.cluster_name]
    command     = "aws"
  }
}

# provider "namedotcom" {
#   username = var.username
#   token    = var.token
# }