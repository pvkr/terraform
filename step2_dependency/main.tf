provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_s3_bucket" "s3_log" {
  bucket = "pvkr-terraform-s3-log"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "s3" {
  bucket = "pvkr-terraform-s3"
  acl    = "private"

  logging {
    target_bucket = "${aws_s3_bucket.s3_log.id}"
    target_prefix = "log/"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0ebe657bc328d4e82"
  instance_type = "t2.micro"

  depends_on = ["aws_s3_bucket.s3"]

  tags {
    Name = "terraform-ec2"
  }
}
