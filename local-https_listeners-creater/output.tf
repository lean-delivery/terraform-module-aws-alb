output "aws_acm_certificate_arn" {
  value = "${local.aws_acm_certificate_arn}"
}
output "aws_acm_certificate_map" {
  value = "${local.aws_acm_certificate_map}"
}

output "https_listeners_list" {
  description = "List of maps aws acm certificates - certificate_arn and port"
  value = "${local.https_listeners_list}"
}

output "root_domain_hosted_zone_id" {
  value = "${element(data.aws_route53_zone.alb.*.zone_id, "0")}"
}

output "alb_custom_dns_name" {
  description = "The custom DNS name of the load balancer."
  value       = "${element(aws_route53_record.alb.*.name, "0")}"
}
