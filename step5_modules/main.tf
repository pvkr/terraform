provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "${var.aws_region}"
}

module "vpc" {
  source               = "./modules/vpc"
  azs                  = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24", "10.0.5.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24", "10.0.6.0/24"]
}

module "sg1" {
  source        = "./modules/sg"
  name          = "TF Public Security Group"
  vpc_id        = "${module.vpc.vpc_id}"
  rule_type     = ["ingress", "ingress", "ingress", "egress"]
  rule_port     = ["80", "22", "-1", "0"]
  rule_protocol = ["tcp", "tcp", "icmp", "-1"]
  rule_cidr     = ["0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
}

module "sg2" {
  source        = "./modules/sg"
  name          = "TF Private Security Group"
  vpc_id        = "${module.vpc.vpc_id}"
  rule_type     = ["ingress", "ingress", "egress"]
  rule_port     = ["22", "-1", "0"]
  rule_protocol = ["tcp", "icmp", "-1"]
  rule_cidr     = ["10.0.0.0/16", "10.0.0.0/16", "0.0.0.0/0"]
}
