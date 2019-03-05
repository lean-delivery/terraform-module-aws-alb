resource "aws_security_group" "allow_in80_in443_outALL" {
  name        = "allow-in_80-in_443-out_ALL-${var.project}-${var.environment}"
  description = "Allow inbound traffic on ports 80 and 443"
  vpc_id      = "${var.vpc_id}"
  tags        = "${local.default_tags}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_port" {
  count             = "${length(var.ports_for_security_group)}"
  from_port         = "${lookup(var.ports_for_security_group[count.index], "port")}"
  to_port           = "${lookup(var.ports_for_security_group[count.index], "port")}"
  cidr_blocks       = ["${lookup(var.ports_for_security_group[count.index], "cidr")}"]
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = "${aws_security_group.allow_in80_in443_outALL.id}"
}
