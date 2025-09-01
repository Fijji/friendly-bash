terraform {
  backend "s3" {
    bucket         = "kpotapenko-lesson-5-tfstate-20250901"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
