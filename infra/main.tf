provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "examples123" {
  bucket = "my-terraform-cicd-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket" "second_bucket" {
  bucket = "my-second-terraform-bucket-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

output "bucket_name" {
  value = aws_s3_bucket.examples123.bucket
}

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
