resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.name_suffix} VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidrs[count.index]}"
  availability_zone = "${var.azs[count.index]}"

  tags {
    Name = "${var.name_suffix} Public Subnet ${count.index}"
  }
}

resource "aws_subnet" "private-subnet" {
  count  = "${length(var.azs)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.private_subnet_cidrs[count.index]}"
  availability_zone = "${var.azs[count.index]}"

  tags {
    Name = "${var.name_suffix} Private Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name_suffix} IGW"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "${var.name_suffix} Public Subnet RT"
  }
}

resource "aws_route_table_association" "public-rt" {
  count     = "${length(var.azs)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public-rt.id}"
}
