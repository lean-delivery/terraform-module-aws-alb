variable "acm_cert_domain" {
  type = "string"
  description = "Domain name for which ACM certificate was created"
  default = ""
}

variable "root_domain" {
  type = "string"
  description = "Root domain in which custom DNS record for ALB would be created"
  default = ""
}

variable "zone_id" {
  type = "string"
  description = "variable to pass zone_id to the module"
}

variable "dns_name" {
  type = "string"
  description = "own aws_route53_record dns_name instead dns_name from alb" #???
}

variable "name" {
  type = "string"
  description = "own aws_route53_record name instead default project-environment-aws_region_current_name.root_domain"
}

variable "most_recent_certificate" {
  type = "string"
  description = "Triger to use most recent SSL certificate"
  default     = "false"
}

variable "default_https_tcp_listeners_port" {
  type = "string"
  default     = "443"
  description = "Port of default HTTPs listener"
}



