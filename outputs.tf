output "alb_sg_id" {
  description = "The ID of main security group for ALB."
  value       = "${aws_security_group.allow_in80_in443_outALL.id}"
}

output "alb_sg_ingress" {
  description = "The Ingress rule of main security group for ALB."
  value       = "${aws_security_group.allow_in80_in443_outALL.ingress}"
}

output "alb_sg_egress" {
  description = "The Egress rule of main security group for ALB."
  value       = "${aws_security_group.allow_in80_in443_outALL.egress}"
}

output "alb_s3_logs" {
  description = "S3 bucket name for storing ALB logs."
  value       = "${element(concat(aws_s3_bucket.alb-logs.*.id, list("")), 0)}"
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = "${module.alb.dns_name}"
}

output "alb_http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = "${module.alb.http_tcp_listener_arns}"
}

output "alb_http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = "${module.alb.http_tcp_listener_ids}"
}

output "alb_https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = "${module.alb.https_listener_arns}"
}

output "alb_https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = "${module.alb.https_listener_ids}"
}

output "load_balancer_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = "${module.alb.load_balancer_arn_suffix}"
}

output "load_balancer_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = "${module.alb.load_balancer_id}"
}

output "load_balancer_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = "${module.alb.load_balancer_zone_id}"
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = "${module.alb.target_group_arn_suffixes}"
}

output "alb_target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = "${module.alb.target_group_arns}"
}

output "alb_target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = "${module.alb.target_group_names}"
}

output "aws_acm_certificate_list" {
  value       = "${local.https_listeners_list}"
  description = "List of maps aws acm certificates - certificate_arn and port"
}

output "root_domain_hosted_zone_id" {
  value = "${element(data.aws_route53_zone.alb.*.zone_id, "0")}"
}

output "alb_custom_dns_name" {
  value       = "${element(aws_route53_record.alb.*.name, "0")}"
  description = "The custom DNS name of the load balancer."
}
