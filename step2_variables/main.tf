provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "${var.aws_region}"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "TF VPC"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "eu-central-1a"

  tags {
    Name = "TF Public Subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "eu-central-1a"

  tags {
    Name = "TF Private Subnet"
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

resource "aws_security_group" "sg-web" {
  name = "TF Web SG"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  vpc_id="${aws_vpc.main.id}"
}

resource "aws_security_group" "sg-db" {
  name = "TF DB SG"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }


  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_key_pair" "main" {
  key_name = "tf_keypair"
  public_key = "${file("${var.key_path}")}"
}

resource "aws_instance" "web" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "${aws_key_pair.main.id}"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sg-web.id}"]
   associate_public_ip_address = true
   user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                echo "<html><h1>Hello from terraform</h1></html>" > /var/www/html/index.html
                service httpd start
                EOF

  tags {
    Name = "TF webserver"
  }
}
