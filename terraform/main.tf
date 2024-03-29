provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

// lookup the current account id
data "aws_caller_identity" "current" {}

// create a mock service fronted by an internal ALB
module "service" {
  source     = "./service"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}

// Now we can create a private link to share the service with other accounts

module "priavate-link" {
  source     = "./private-link"
  depends_on = [module.service]
  vpc_id     = module.vpc.vpc_id
  security_groups = [
    module.vpc.default_security_group_id
  ]
  alb_arn    = module.service.alb_arn
  subnet_ids = module.vpc.private_subnets

  allowed_principals = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  ]
}

output "private_link_service_name" {
  value = module.priavate-link.service_name
}
