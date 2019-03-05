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

variable "own_name" {
  description = "own aws_route53_record name instead default project-environment-aws_region_current_name.root_domain"
  default     = ""
}

variable "own_dns_name" {
  description = "own aws_route53_record dns_name instead dns_name from alb" #???
  default     = ""
}

variable "enable_cross_zone_load_balancing" {
  type        = "string"
  description = " Indicates whether cross zone load balancing should be enabled in application load balancers"
  default     = "false"
}

variable "enable_deletion_protection" {
  type        = "string"
  description = " If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false"
  default     = "false"
}

variable "enable_http2" {
  type        = "string"
  description = " Indicates whether HTTP/2 is enabled in application load balancers"
  default     = "true"
}

variable "extra_ssl_certs" {
  type        = "list"
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values - certificate_arn https_listener_index"
  default     = []
}

variable "extra_ssl_certs_count" {
  type        = "string"
  description = "A manually provided count/length of the extra_ssl_certs list of maps since the list cannot be computed"
  default     = "0"
}

variable "idle_timeout" {
  type        = "string"
  description = " The time in seconds that the connection is allowed to be idle"
  default     = "60"
}

variable "ip_address_type" {
  type        = "string"
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack"
  default     = "ipv4"
}

variable "listener_ssl_policy_default" {
  type        = "string"
  description = "The security policy if using HTTPS externally on the load balancer"
  default     = "ELBSecurityPolicy-2016-08"
}

variable "load_balancer_create_timeout" {
  type        = "string"
  description = " Timeout value when creating the ALB"
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  type        = "string"
  description = " Timeout value when deleting the ALB"
  default     = "10m"
}

variable "load_balancer_is_internal" {
  type        = "string"
  description = "Boolean determining if the load balancer is internal or externally facing"
  default     = "false"
}

variable "load_balancer_update_timeout" {
  type        = "string"
  description = " Timeout value when updating the ALB"
  default     = "10m"
}

variable "log_location_prefix" {
  type        = "string"
  description = "S3 prefix within the log_bucket_name under which logs are stored"
  default     = ""
}

variable "ports_for_security_group" {
  type        = "list"
  description = "ports that will be open to additional security_group"

  default = [
    {
      port = "80"
      cidr = "0.0.0.0/0"
    },
    {
      port = "443"
      cidr = "0.0.0.0/0"
    },
  ]
}
