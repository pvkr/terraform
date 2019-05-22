terraform {
  backend "s3" {
    bucket = "pvkr-terraform-s3-state"
    key    = "tf/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_s3_bucket" "ts3" {
  bucket = "pvkr-terraform-s3-test"
  acl    = "private"

  tags {
    Name = "pvkr-terraform-s3-test"
  }
}
