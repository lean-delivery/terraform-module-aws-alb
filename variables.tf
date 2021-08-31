variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer"
  type        = list(string)
  default     = null
}

variable "project" {
  description = "Project name (used for resource naming and tagging)"
  type        = string
  default     = "project"
}

variable "environment" {
  description = "Environment name (used for resource naming and tagging)"
  type        = string
  default     = "test"
}

variable "enable_logging" {
  description = "Trigger to enable ALB logging"
  type        = bool
  default     = true
}

variable "enable_subdomains" {
  description = "Trigger to add '*.' before ALB custom domain name"
  type        = bool
  default     = false
}

variable "default_load_balancer_is_internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Enforces destruction of S3 bucket with ALB logs"
  type        = bool
  default     = true
}

variable "default_http_tcp_listeners_port" {
  description = "Port of default HTTP listener"
  type        = number
  default     = 80
}

variable "default_https_tcp_listeners_port" {
  description = "Port of default HTTPs listener"
  type        = number
  default     = 443
}

variable "default_target_groups_port" {
  description = "Port of default target group"
  type        = number
  default     = 80
}

variable "target_type" {
  description = "Type of target that you must specify when registering targets with this target group."
  type = string
  default = "instance"
}

variable "deregistration_delay" {
  description = "Amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  type = number
  default = 300
}

variable "slow_start" {
  description = "Amount time for targets to warm up before the load balancer sends them a full share of requests."
  type = number
  default = 0
}

variable "proxy_protocol_v2" {
  description = "Whether to enable support for proxy protocol v2 on Network Load Balancers."
  type = bool
  default = false
}

variable "stickiness" {
  description = "Stickiness configuration block."
  type = object({})
  default = {}
}

variable "lambda_multi_value_headers_enabled" {
  description = "Whether the request and response headers exchanged between the load balancer and the Lambda function include arrays of values or strings. Only applies when target_type is lambda"
  type = bool
  default = false
}

variable "load_balancing_algorithm_type" {
  description = "Determines how the load balancer selects targets when routing requests. Only applicable for Application Load Balancer Target Groups."
  type = string
  default = "round_robin"
}

variable "preserve_client_ip" {
  description = "Whether client IP preservation is enabled."
  type = bool
  default = false
}

variable "health_check" {
  description = "Target group health check parameters"
  type        = map(any)

  default     = {
    "enabled"             = true
    "path"                = "/healthcheck"
    "matcher"             = "200"
    "interval"            = 10
    "healthy_threshold"   = 3
    "port"                = "traffic-port"
    "timeout"             = 5
    "unhealthy_threshold" = 3
    "protocol"            = "HTTP"
  }
}

variable "default_target_groups_backend_protocol" {
  description = "Backend protocol of default target group"
  type        = string
  default     = "HTTP"
}

variable "acm_cert_domain" {
  description = "Domain name for which ACM certificate was created"
  type        = string
  default     = ""
}

variable "root_domain" {
  description = "Root domain in which custom DNS record for ALB would be created"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

variable "lb_accout_id_per_region" {
  type    = map(string)
  default = {
    "us-east-1"      = "127311923021"
    "us-east-2"      = "033677994240"
    "us-west-1"      = "027434742980"
    "us-west-2"      = "797873946194"
    "ca-central-1"   = "985666609251"
    "eu-central-1"   = "054676820928"
    "eu-west-1"      = "156460612806"
    "eu-west-2"      = "652711504416"
    "eu-west-3"      = "009996457667"
    "ap-northeast-1" = "582318560864"
    "ap-northeast-2" = "600734575887"
    "ap-northeast-3" = "383597477331"
    "ap-southeast-1" = "114774131450"
    "ap-southeast-2" = "783225319266"
    "ap-south-1"     = "718504428378"
    "sa-east-1"      = "507241528517"
    "us-gov-west-1"  = "048591011584"
    "us-gov-east-1"  = "190560391635"
    "cn-north-1"     = "638102146993"
    "cn-northwest-1" = "037604701340"
  }
}

variable "most_recent_certificate" {
  description = "Trigger to use most recent SSL certificate"
  type        = bool
  default     = false
}

variable "alb_logs_lifecycle_rule_enabled" {
  description = "Enable or disable lifecycle_rule for ALB logs s3 bucket"
  type        = bool
  default     = false
}

variable "alb_logs_expiration_days" {
  description = "s3 lifecycle rule expiration period in days"
  type        = number
  default     = 5
}

variable "alb_custom_security_group" {
  description = "Switch to override default-created security group"
  type        = bool
  default     = false
}

variable "alb_custom_security_group_id" {
  description = "Security group ID that override default-created security group"
  type        = string
  default     = "None"
}

variable "cn_acm" {
  description = "Whether to use acm certificate with AWS China"
  type        = bool
  default     = false
}

variable "cn_route53" {
  description = "Whether to use Route53 in AWS China"
  type        = bool
  default     = false
}

variable "alb_custom_route53_record_name" {
  description = "Custom Route53 record name for ALB"
  type        = string
  default     = ""
}

variable "listener_ssl_policy" {
  description = "The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html)."
  type        = string
  default     = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
}
