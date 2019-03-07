module "alb" {
  source      = "../"
  project     = "Project"
  environment = "dev"
  vpc_id      = "vpc-eizox8ea"
  subnets     = ["subnet-sait0aiw", "subnet-op8phee4", "subnet-eego9xoo"]
}
