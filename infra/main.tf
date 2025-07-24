provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "tf-cicd-${random_string.suffix.result}-us-east-1-864981717146"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

terraform {
  backend "s3" {
    bucket         = "prasanna-terraform-state-864981717146"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}