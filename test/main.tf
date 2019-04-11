resource "aws_vpc" "foo" {
  cidr_block = "10.1.0.0/16"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "foo" {
  vpc_id            = "${aws_vpc.foo.id}"
  cidr_block        = "10.1.1.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

resource "aws_subnet" "bar" {
  vpc_id            = "${aws_vpc.foo.id}"
  cidr_block        = "10.1.2.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

module "alb" {
  source = "../"

  vpc_id  = "${aws_vpc.foo.id}"
  subnets = ["${aws_subnet.foo.id}", "${aws_subnet.bar.id}"]

  acm_cert_domain         = "*.example.com"
  most_recent_certificate = true

  root_domain = "example.com"

  alb_logs_lifecycle_rule_enabled = true
  alb_logs_expiration_days        = "5"
}
