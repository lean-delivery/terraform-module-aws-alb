resource "aws_s3_bucket" "alb-logs" {
  count         = "${ var.enable_logging ? 1 : 0 }"
  bucket        = "${var.project}-${var.environment}-alb-logs"
  acl           = "log-delivery-write"
  force_destroy = "${ lower(var.environment) == "production" ? "false" : var.force_destroy}"
  tags          = "${local.default_tags}"
}

data "aws_iam_policy_document" "alb-logs-policy" {
  count = "${ var.enable_logging ? 1 : 0 }"

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${element(concat(aws_s3_bucket.alb-logs.*.id, list("")), 0)}/*",
    ]

    principals = {
      type        = "AWS"
      identifiers = ["${lookup(var.lb_accout_id_per_region, data.aws_region.current.name)}"]
    }
  }
}

resource "aws_s3_bucket_policy" "alb-logs" {
  count  = "${ var.enable_logging ? 1 : 0 }"
  bucket = "${element(aws_s3_bucket.alb-logs.*.id, count.index)}"
  policy = "${data.aws_iam_policy_document.alb-logs-policy.0.json}"
}
