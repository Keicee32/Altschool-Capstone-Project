#----------------------------------------------------
#              Providers and s3 Backend
#----------------------------------------------------

terraform {
  required_providers {


    namedotcom = {
      source  = "lexfrei/namedotcom"
      version = "~>1.0"
    }
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

provider "namedotcom" {
  username = var.username
  token    = var.token
}