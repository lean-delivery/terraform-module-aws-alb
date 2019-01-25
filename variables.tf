variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed"
}

variable "subnets" {
  type        = "list"
  description = "A list of subnets to associate with the load balancer"
}

variable "project" {
  default     = "project"
  description = "Project name (used for resource naming and tagging)"
}

variable "environment" {
  default     = "test"
  description = "Environment name (used for resource naming and tagging)"
}

variable "enable_logging" {
  default     = "true"
  description = "Trigger to enable ALB logging"
}

variable "force_destroy" {
  default     = "true"
  description = "Enforces destruction of S3 bucket with ALB logs"
}

variable "default_http_tcp_listeners_count" {
  default     = "0"
  description = "Switch to configure default HTTP listener"
}

variable "default_http_tcp_listeners_port" {
  default     = "80"
  description = "Port of default HTTP listener"
}

variable "default_https_tcp_listeners_count" {
  default     = "1"
  description = "Switch to configure default HTTPs listener"
}

variable "default_https_tcp_listeners_port" {
  default     = "443"
  description = "Port of default HTTPs listener"
}

variable "default_target_groups_count" {
  default     = "1"
  description = "Switch to default target group"
}

variable "default_target_groups_port" {
  default     = "80"
  description = "Port of default target group"
}

variable "target_groups_defaults" {
  description = "Target group health check parameters"

  default = {
    "health_check_path"                = "/healthcheck"
    "health_check_matcher"             = "200"
    "cookie_duration"                  = 86400
    "deregistration_delay"             = 300
    "health_check_interval"            = 10
    "health_check_healthy_threshold"   = 3
    "health_check_port"                = "traffic-port"
    "health_check_timeout"             = 5
    "health_check_unhealthy_threshold" = 3
    "stickiness_enabled"               = true
    "target_type"                      = "instance"
  }
}

variable "default_target_groups_backend_protocol" {
  default     = "HTTP"
  description = "Backend protocol of default target group"
}

variable "acm_cert_domain" {
  description = "Domain name for which ACM certificate was created"
  default     = ""
}

variable "root_domain" {
  default     = ""
  description = "Root domain in which custom DNS record for ALB would be created"
}

variable "tags" {
  type        = "map"
  description = "Additional tags for resources"
  default     = {}
}

variable "lb_accout_id_per_region" {
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
  description = "Triger to use most recent SSL certificate"
  default     = "false"
}
