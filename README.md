# Summary

Terraform module to setup AWS ALB with required parameters.

Based on Hashicorp's [ALB module](https://github.com/terraform-aws-modules/terraform-aws-alb). In addition can configure S3 bucket to store ALB logs, Route53 record with custom DNS name and setup security group.

## Example

```HCL
module "alb" {
  source = "github.com/lean-delivery/tf-module-aws-alb"

  project     = "Project"
  environment = "dev"

  vpc_id  = "vpc-eizox8ea"
  subnets = ["subnet-sait0aiw", "subnet-op8phee4", "subnet-eego9xoo"]

  acm_cert_domain = "*.project.example.com"
  root_domain     = "example.com"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acm\_cert\_domain | Domain name for which ACM certificate was created | string | `` | no |
| default\_http\_tcp\_listeners\_count | Switch to configure default HTTP listener | string | `0` | no |
| default\_http\_tcp\_listeners\_port | Port of default HTTP listener | string | `80` | no |
| default\_https\_tcp\_listeners\_count | Switch to configure default HTTPs listener | string | `1` | no |
| default\_https\_tcp\_listeners\_port | Port of default HTTPs listener | string | `443` | no |
| default\_target\_groups\_backend\_protocol | Backend protocol of default target group | string | `HTTP` | no |
| default\_target\_groups\_count | Switch to default target group | string | `1` | no |
| default\_target\_groups\_port | Port of default target group | string | `80` | no |
| enable\_logging | Trigger to enable ALB logging | string | `true` | no |
| environment | Environment name (used for resource naming and tagging) | string | `test` | no |
| force\_destroy | Enforces destruction of S3 bucket with ALB logs | string | `true` | no |
| lb\_accout\_id\_per\_region | - | map | `<map>` | no |
| most\_recent\_certificate | Triger to use most recent SSL certificate | string | `false` | no |
| project | Project name (used for resource naming and tagging) | string | `project` | no |
| root\_domain | Root domain in which custom DNS record for ALB would be created | string | `` | no |
| subnets | A list of subnets to associate with the load balancer | list | - | yes |
| tags | Additional tags for resources | map | `<map>` | no |
| target\_groups\_defaults | Target group health check parameters | map | `<map>` | no |
| vpc\_id | VPC id where the load balancer and other resources will be deployed | string | - | yes |
| own\_name | own aws\_route53\_record name instead default project-environment-aws\_region\_current\_name.root\_domain | string | "" | no |
| own\_dns\_name | own aws\_route53\_record dns\_name instead dns\_name from alb | string | "" | no |
| enable\_cross\_zone\_load\_balancing | Indicates whether cross zone load balancing should be enabled in application load balancers | string | false | no |
| enable\_deletion\_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false | string | false | no |
| enable\_http2 | Indicates whether HTTP/2 is enabled in application load balancers | string | true | no |
| extra\_ssl\_certs | A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values - certificate\_arn https\_listener\_index | list | [] | no |
| extra\_ssl\_certs\_count | A manually provided count/length of the extra\_ssl\_certs list of maps since the list cannot be computed | string | "0" | no |
| idle\_timeout | The time in seconds that the connection is allowed to be idle | string | "60" | no |
| ip\_address\_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack | string | "ipv4" | no |
| listener\_ssl\_policy\_default | The security policy if using HTTPS externally on the load balancer | string | "ELBSecurityPolicy-2016-08" | no |
| load\_balancer\_create\_timeout | Timeout value when creating the ALB | string | "10m" | no |
| load\_balancer\_delete\_timeout | Timeout value when deleting the ALB | string | "10m" | no |
| load\_balancer\_is\_internal | Boolean determining if the load balancer is internal or externally facing | string | "false" | no |
| load\_balancer\_update\_timeout | Timeout value when updating the ALB | string | "10m" | no |
| log\_location\_prefix | S3 prefix within the log\_bucket\_name under which logs are stored | string | "" | no |
| ports\_for\_security\_group | ports that will be open to additional security\_group | list | [{port = "80" cidr = "0.0.0.0/0"}, {port = "443" cidr = "0.0.0.0/0"}] | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_custom\_dns\_name | The custom DNS name of the load balancer. |
| alb\_dns\_name | The DNS name of the load balancer. |
| alb\_http\_tcp\_listener\_arns | The ARN of the TCP and HTTP load balancer listeners created. |
| alb\_http\_tcp\_listener\_ids | The IDs of the TCP and HTTP load balancer listeners created. |
| alb\_https\_listener\_arns | The ARNs of the HTTPS load balancer listeners created. |
| alb\_https\_listener\_ids | The IDs of the load balancer listeners created. |
| alb\_s3\_logs | S3 bucket name for storing ALB logs. |
| alb\_sg\_egress | The Egress rule of security group for ALB. |
| alb\_sg\_id | The ID of security group for ALB. |
| alb\_sg\_ingress | The Ingress rule of security group for ALB. |
| alb\_target\_group\_arns | ARNs of the target groups. Useful for passing to your Auto Scaling group. |
| alb\_target\_group\_names | Name of the target group. Useful for passing to your CodeDeploy Deployment Group. |
| load\_balancer\_arn\_suffix | ARN suffix of our load balancer - can be used with CloudWatch. |
| load\_balancer\_id | The ID and ARN of the load balancer we created. |
| load\_balancer\_zone\_id | The zone_id of the load balancer to assist with creating DNS records. |
| root\_domain\_hosted\_zone\_id | - |
| target\_group\_arn\_suffixes | ARN suffixes of our target groups - can be used with CloudWatch. |
| aws\_acm\_certificate\_list | List of maps aws acm certificates - certificate_arn and port |

## License

Apache2.0 Licensed. See [LICENSE](https://github.com/lean-delivery/tf-module-aws-alb/tree/master/LICENSE) for full details.
