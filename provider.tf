provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}
module "vpc"{
  source = "./modules/vpc"
}
module "ec2"{
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}
