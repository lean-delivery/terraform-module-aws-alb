data "aws_acm_certificate" "this" {
  count       = "${var.acm_cert_domain != "" ? 1 : 0}"
  domain      = "${var.acm_cert_domain}"
  statuses    = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = "${var.most_recent_certificate}"
}

data "aws_route53_zone" "alb" {
  count = "${var.root_domain != "" ? 1 : 0}"
  name  = "${var.root_domain}."
}

resource "aws_route53_record" "alb" {
  count   = "${var.root_domain != "" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.alb.zone_id}"
  name    = "${var.name}"
  type    = "A"

  alias {
    name                   = "${var.dns_name}"
    zone_id                = "${var.zone_id}"
    evaluate_target_health = true
  }
}

locals {
  aws_acm_certificate_arn = "${ var.acm_cert_domain == "" ? "" : element(concat(data.aws_acm_certificate.this.*.arn, list("")), "0" ) }" # not empty list
  aws_acm_certificate_map_arn  = "${merge(map(), map( "${var.acm_cert_domain}" == "" ? "" : "certificate_arn", "${"${var.acm_cert_domain}" == "" ? "" : "${local.aws_acm_certificate_arn}"}"         ))}"
  aws_acm_certificate_map_port = "${merge(map(), map( "${var.acm_cert_domain}" == "" ? "" : "port",            "${"${var.acm_cert_domain}" == "" ? "" : "${var.default_https_tcp_listeners_port}"}"  ))}"
  aws_acm_certificate_map      = "${merge(map(), local.aws_acm_certificate_map_arn, local.aws_acm_certificate_map_port)}"
  https_listeners_list = "${list(local.aws_acm_certificate_map)}"
}
