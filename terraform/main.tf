provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

module "service" {
  source     = "./service"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}
