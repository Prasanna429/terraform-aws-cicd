provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "tf-cicd-hx4v19lt" # Matches existing bucket
}

# Remove random_string.suffix to simplify and avoid replacement
# If you need dynamic names later, we can reintroduce it
terraform {
  backend "s3" {
    bucket         = "prasanna-terraform-state-864981717146"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}