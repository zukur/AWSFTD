terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  #access_key = ""
  #secret_key = ""
  region  = var.region
}