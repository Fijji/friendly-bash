terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "kpotapenko-lesson-7-tfstate-20250909"
    key            = "lesson-db-module/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks-lesson7"
    encrypt        = true
  }

  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" {
  region = var.region
}



