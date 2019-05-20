provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_s3_bucket" "ts3" {
  bucket = "pvkr-terraform-s3-bucket"
  acl    = "private"

  tags {
    Name = "terraform-s3-bucket"
  }
}
