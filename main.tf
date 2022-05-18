locals {
  subdomains = var.enable_subdomains ? "*." : ""
}

data "aws_partition" "current" {
}

resource "aws_security_group" "allow_in80_in443_outALL" {
  count       = var.alb_custom_security_group ? 0 : 1
  name        = "allow-in_80-in_443-out_ALL-${var.project}-${var.environment}"
  description = "Allow inbound traffic on ports 80 and 443"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "alb-logs" {
  count         = var.enable_logging ? 1 : 0
  bucket        = "${var.project}-${var.environment}-alb-logs"
  acl           = "log-delivery-write"
  force_destroy = lower(var.environment) == "production" ? "false" : var.force_destroy

  lifecycle_rule {
    enabled = var.alb_logs_lifecycle_rule_enabled

    expiration {
      days = var.alb_logs_expiration_days
    }
  }
}

data "aws_region" "current" {
}

data "aws_iam_policy_document" "alb-logs-policy" {
  count = var.enable_logging ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:s3:::${element(concat(aws_s3_bucket.alb-logs.*.id, [""]), 0)}/*",
    ]

    principals {
      type = "AWS"
      # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
      # force an interpolation expression to be interpreted as a list by wrapping it
      # in an extra set of list brackets. That form was supported for compatibility in
      # v0.11, but is no longer supported in Terraform v0.12.
      #
      # If the expression in the following list itself returns a list, remove the
      # brackets to avoid interpretation as a list of lists. If the expression
      # returns a single list item then leave it as-is and remove this TODO comment.
      identifiers = [var.lb_accout_id_per_region[data.aws_region.current.name]]
    }
  }
}

resource "aws_s3_bucket_policy" "alb-logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = element(aws_s3_bucket.alb-logs.*.id, count.index)

  policy = data.aws_iam_policy_document.alb-logs-policy[0].json
}

data "aws_acm_certificate" "this" {
  domain      = var.acm_cert_domain
  statuses    = ["ISSUED", "PENDING_VALIDATION"]
  most_recent = var.most_recent_certificate
  count       = 1
  #count       = data.aws_partition.current.partition == "aws" ? 1 : var.cn_acm == true ? 1 : 0
}

data "aws_iam_server_certificate" "ss_cert" {
  name   = "${data.aws_region.current.name}.elb.amazonaws.com.cn"
  latest = true
  count = 0
  #count  = data.aws_partition.current.partition == "aws-cn" ? var.cn_acm == false ? 1 : 0 : 0
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "4.2.0"

  load_balancer_name        = "${var.project}-${var.environment}"
  load_balancer_is_internal = var.default_load_balancer_is_internal
  security_groups = [element(
    concat(
      aws_security_group.allow_in80_in443_outALL.*.id,
      [var.alb_custom_security_group_id],
    ),
    0,
  )]
  subnets = var.subnets
  vpc_id  = var.vpc_id

  /////// Configure listeners and target groups ///////
  https_listeners = [
    {
      "certificate_arn" = element(
        concat(
          data.aws_acm_certificate.this.*.arn,
          data.aws_iam_server_certificate.ss_cert.*.arn,
        ),
        0,
      )
      "port" = var.default_https_tcp_listeners_port
    },
  ]
  https_listeners_count = var.default_https_tcp_listeners_count

  http_tcp_listeners = [
    {
      "port"     = var.default_http_tcp_listeners_port
      "protocol" = "HTTP"
    },
  ]
  http_tcp_listeners_count = var.default_http_tcp_listeners_count

  target_groups = [
    {
      "name"             = "${var.project}-${var.environment}"
      "backend_protocol" = var.default_target_groups_backend_protocol
      "backend_port"     = var.default_target_groups_port
    },
  ]
  target_groups_count = var.default_target_groups_count

  logging_enabled = var.enable_logging
  log_bucket_name = element(concat(aws_s3_bucket.alb-logs.*.id, [""]), 0)
  tags            = var.tags

  target_groups_defaults = var.target_groups_defaults
}

data "aws_route53_zone" "alb" {
  name  = "${var.root_domain}."
  #count = data.aws_partition.current.partition == "aws" ? 1 : var.cn_route53 == true ? 1 : 0
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.alb.zone_id
  name    = var.alb_custom_route53_record_name == "" ? "${var.project}-${var.environment}-${data.aws_region.current.name}.${var.root_domain}" : var.alb_custom_route53_record_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.load_balancer_zone_id
    evaluate_target_health = true
  }

  #count = data.aws_partition.current.partition == "aws" ? 1 : var.cn_route53 == true ? 1 : 0
}

resource "aws_route53_record" "alb-subdomain" {
  count = var.enable_subdomains == true ? 1 : 0

  zone_id = data.aws_route53_zone.alb.zone_id
  name    = var.alb_custom_route53_record_name == "" ? "${local.subdomains}${var.project}-${var.environment}-${data.aws_region.current.name}.${var.root_domain}" : "${local.subdomains}${var.alb_custom_route53_record_name}"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.load_balancer_zone_id
    evaluate_target_health = true
  }
}

