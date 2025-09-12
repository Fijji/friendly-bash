terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket         = "kpotapenko-lesson-8-9-tfstate-20250909"
    key            = "lesson-8-9/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks-lesson7"
    encrypt        = true
  }

  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">= 2.28" }
    helm = { source = "hashicorp/helm", version = ">= 2.11" }
  }
}
