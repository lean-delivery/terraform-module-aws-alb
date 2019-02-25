# Summary

The module that forms the route53 resources. Made as a separate module so that ALB can be installed with or without route53. Returns https_listeners for the ALB module (empty if acm_cert_domain and root_domain were not specified)

## Example

```HCL
module "https_listeners" {
  source                           = "local-https_listeners-creater/"
  acm_cert_domain                  = "*.project.example.com"
  root_domain                      = "example.com"
  name                             = "example_project"
  default_https_tcp_listeners_port = "443"
  zone_id                          = "${module.alb.load_balancer_zone_id}" (pass from alb module)
  dns_name                         = "${module.alb.dns_name}" (pass from alb module)
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm_cert_domain | Domain name for which ACM certificate was created | string | "" | no |
| root_domain | Root domain in which custom DNS record for ALB would be created | string | "" | no |
| zone_id | variable to pass zone_id to the module | string | - | yes |
| dns_name | own aws_route53_record dns_name instead dns_name from alb | string | - | yes |
| name | own aws_route53_record name instead default project-environment-aws_region_current_name.root_domain | string | - | yes |
| most_recent_certificate | Triger to use most recent SSL certificate | string | "false" | no |
| default_https_tcp_listeners_port | Port of default HTTPs listener | string | "443" | no |


## Outputs

| Name | Description |
|------|-------------|
| aws_acm_certificate_arn | "" |
| aws_acm_certificate_map | "" |
| https_listeners_list | "List of maps aws acm certificates - certificate_arn and port" |
| root_domain_hosted_zone_id | "" |
| alb_custom_dns_name | "The custom DNS name of the load balancer." |
