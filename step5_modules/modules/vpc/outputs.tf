output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public-subnet-ids" {
  value = "${aws_subnet.public-subnet.*.id}"
}

output "private-subnet-ids" {
  value = "${aws_subnet.private-subnet.*.id}"
}
