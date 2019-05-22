provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "${var.aws_region}"
}

resource "aws_s3_bucket" "ts3" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags {
    Name = "terraform-s3-bucket"
  }
}
