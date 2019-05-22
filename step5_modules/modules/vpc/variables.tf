variable "azs" {
  type = "list"
}

variable "vpc_cidr" {
}

variable "public_subnet_cidrs" {
  type = "list"
}

variable "private_subnet_cidrs" {
  type = "list"
}

variable "name_suffix" {
  default = "TF"
}
