terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kind = {
      source  = "kinvolk/kind"
      version = "~> 0.1"
    }
  }

  backend "s3" {
    bucket         = "tonyblair-terraform-backend"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      BillingID = "tonyblair-Team"
      Project   = "tonyblair-Cluster"
      terraform = true
    }
  }
}
