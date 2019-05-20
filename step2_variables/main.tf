provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "eu-central-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "terraform_vpc"
  }
}
#
# resource "aws_subnet" "subnet1_pub" {
#   vpc_id            = "${aws_vpc.main.id}"
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "eu-central-1a"
#
#   tags = {
#     Name = "terraform_subnet1_pub"
#   }
# }

# resource "aws_subnet" "subnet1_priv" {
#   vpc_id            = "${aws_vpc.main.id}"
#   cidr_block        = "10.0.2.0/24"
#   availability-zone = "eu-central-1a"
#
#   tags = {
#     Name = "terraform_subnet1_priv"
#   }
# }


# resource "aws_s3_bucket" "ts3" {
#   bucket = "terraform-s3-bucket"
#   acl = "private"
#
#   tags {
#     Name = "terraform-s3-bucket"
#   }
# }
