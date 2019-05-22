resource "aws_security_group" "sg" {
  name   = "${var.name}"
  vpc_id ="${var.vpc_id}"
}

resource "aws_security_group_rule" "sg-rule" {
  count             = "${length(var.rule_type)}"
  type              = "${var.rule_type[count.index]}"
  from_port         = "${var.rule_port[count.index]}"
  to_port           = "${var.rule_port[count.index]}"
  protocol          = "${var.rule_protocol[count.index]}"
  cidr_blocks       = ["${var.rule_cidr[count.index]}"]
  security_group_id = "${aws_security_group.sg.id}"
}
