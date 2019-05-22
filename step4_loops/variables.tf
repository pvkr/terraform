variable "aws_region" {
  description = "Region for the VPC"
  default = "eu-central-1"
}

variable "azs" {
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs for the public subnet"
  default = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs for the private subnet"
  default = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

variable "name_suffix" {
  default = "TF"
}
