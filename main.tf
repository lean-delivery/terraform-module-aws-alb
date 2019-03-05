locals {
  default_tags = {
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  auto_generated_name          = "${var.project}-${var.environment}-${data.aws_region.current.name}.${var.root_domain}"
  aws_acm_certificate_arn      = "${ var.acm_cert_domain == "" ? "" : element(concat(data.aws_acm_certificate.this.*.arn, list("")), "0" ) }"
  aws_acm_certificate_map_arn  = "${merge(map(), map( "${var.acm_cert_domain}" == "" ? "" : "certificate_arn", "${"${var.acm_cert_domain}" == "" ? "" : "${local.aws_acm_certificate_arn}"}"         ))}"
  aws_acm_certificate_map_port = "${merge(map(), map( "${var.acm_cert_domain}" == "" ? "" : "port",            "${"${var.acm_cert_domain}" == "" ? "" : "${var.default_https_tcp_listeners_port}"}"  ))}"
  aws_acm_certificate_map      = "${merge(map(), local.aws_acm_certificate_map_arn, local.aws_acm_certificate_map_port)}"
  https_listeners_list         = "${list(local.aws_acm_certificate_map)}"
}

data "aws_region" "current" {}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "3.5.0"

  load_balancer_name = "${var.project}-${var.environment}"
  security_groups    = ["${aws_security_group.allow_in80_in443_outALL.id}"]
  subnets            = "${var.subnets}"
  vpc_id             = "${var.vpc_id}"

  /// Configure listeners and target groups ///////
  https_listeners                  = "${local.https_listeners_list}"
  https_listeners_count            = "${ var.acm_cert_domain != "" ? var.default_https_tcp_listeners_count : 0 }"
  http_tcp_listeners               = "${list(map("port", "${var.default_http_tcp_listeners_port}", "protocol", "HTTP"))}"
  http_tcp_listeners_count         = "${var.default_http_tcp_listeners_count}"
  target_groups                    = "${list(map("name", "${var.project}-${var.environment}", "backend_protocol", "${var.default_target_groups_backend_protocol}", "backend_port", "${var.default_target_groups_port}"))}"
  target_groups_count              = "${var.default_target_groups_count}"
  logging_enabled                  = "${var.enable_logging}"
  log_bucket_name                  = "${element(concat(aws_s3_bucket.alb-logs.*.id, list("")), 0)}"
  tags                             = "${merge(local.default_tags, var.tags)}"
  target_groups_defaults           = "${var.target_groups_defaults}"
  enable_cross_zone_load_balancing = "${var.enable_cross_zone_load_balancing}"
  enable_deletion_protection       = "${var.enable_deletion_protection}"
  enable_http2                     = "${var.enable_http2}"
  extra_ssl_certs                  = "${var.extra_ssl_certs}"
  extra_ssl_certs_count            = "${var.extra_ssl_certs_count}"
  idle_timeout                     = "${var.idle_timeout}"
  ip_address_type                  = "${var.ip_address_type}"
  listener_ssl_policy_default      = "${var.listener_ssl_policy_default}"
  load_balancer_create_timeout     = "${var.load_balancer_create_timeout}"
  load_balancer_delete_timeout     = "${var.load_balancer_delete_timeout}"
  load_balancer_is_internal        = "${var.load_balancer_is_internal}"
  load_balancer_update_timeout     = "${var.load_balancer_update_timeout}"
  log_location_prefix              = "${var.log_location_prefix}"
}

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
  name    = "${var.own_name != "" ? var.own_name : local.auto_generated_name}"
  type    = "A"

  alias {
    name                   = "${var.own_dns_name != "" ? var.own_dns_name : module.alb.dns_name}" #???
    zone_id                = "${module.alb.load_balancer_zone_id}"
    evaluate_target_health = true
  }
}
