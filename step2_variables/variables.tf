variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "../id_rsa.pub"
}

variable "ami" {
  description = "Amazon Linux 2 AMI"
  default = "ami-0ebe657bc328d4e82"
}
