provider "aws" {
  shared_credentials_file = "../../.creds"
  region                  = "eu-central-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "TF VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags {
    Name = "TF Public Subnet 1"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1a"

  tags {
    Name = "TF Private Subnet 1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "TF IGW"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "TF Public Subnet RT"
  }
}

resource "aws_route_table_association" "public-rt" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
