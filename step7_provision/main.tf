provider "aws" {
  shared_credentials_file = "../.creds"
  region                  = "${var.aws_region}"
}

module "vpc" {
  source               = "../step5_modules/modules/vpc"
  azs                  = ["eu-central-1a"]
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
}

module "sg1" {
  source        = "../step5_modules/modules/sg"
  name          = "TF Public Security Group"
  vpc_id        = "${module.vpc.vpc_id}"
  rule_type     = ["ingress", "ingress", "ingress", "egress"]
  rule_port     = ["80", "22", "-1", "0"]
  rule_protocol = ["tcp", "tcp", "icmp", "-1"]
  rule_cidr     = ["0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
}

module "sg2" {
  source        = "../step5_modules/modules/sg"
  name          = "TF Private Security Group"
  vpc_id        = "${module.vpc.vpc_id}"
  rule_type     = ["ingress"]
  rule_port     = ["-1"]
  rule_protocol = ["icmp"]
  rule_cidr     = ["10.0.0.0/16"]
}

resource "aws_key_pair" "main" {
  key_name = "tf_keypair"
  public_key = "${file("../id_rsa.pub")}"
}

resource "aws_instance" "web1" {
  ami  = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.main.id}"
  subnet_id = "${module.vpc.public-subnet-ids[0]}"
  vpc_security_group_ids = ["${module.sg1.sg_id}"]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "<html><h1>Hello from terraform</h1></html>" > /var/www/html/index.html
              service httpd start
              EOF
  tags {
    Name = "Apache webserver "
  }
}

resource "aws_instance" "web_javaapp" {
  ami  = "${var.ami}" # ami-9dc0c376 includes java
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.main.id}"
  subnet_id = "${module.vpc.public-subnet-ids[0]}"
  vpc_security_group_ids = ["${module.sg1.sg_id}"]
  associate_public_ip_address = true

  provisioner "file" {
    source      = "./pizza-registry-1.0.jar"
    destination = "/tmp/pizza-registry-1.0.jar"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = ""
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y java-1.8.0-openjdk",
      "nohup sudo java -jar /tmp/pizza-registry-1.0.jar --server.port=80 &",
      "sleep 10"
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = ""
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }

  provisioner "local-exec" {
    command = "curl http://${aws_instance.web_javaapp.public_ip}/pizza-registry/pizzas > provision.log"
    on_failure = "continue"
  }

  tags {
    Name = "SpringBoot example"
  }
}

resource "aws_instance" "ec2_backend" {
  ami  = "${var.ami}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.main.id}"
  subnet_id = "${module.vpc.private-subnet-ids[0]}"
  vpc_security_group_ids = ["${module.sg2.sg_id}"]

  tags {
    Name = "TF backend"
  }
}
