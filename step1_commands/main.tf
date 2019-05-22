provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_s3_bucket" "s3" {
  bucket = "pvkr-terraform-s3"
  acl    = "private"

  tags {
    Name = "terraform-s3"
  }
}
