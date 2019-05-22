provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_s3_bucket" "s3" {
  bucket = "pvkr-terraform-s3-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags {
    Name = "pvkr-terraform-s3-state"
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
attribute {
    name = "LockID"
    type = "S"
  }
}