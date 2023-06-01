provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}
terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
module "vpc"{
  source = "./modules/vpc"
}
module "ec2"{
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}
module "ALB" {
   source = "./modules/ALB"
   vpc_id = module.vpc.vpc_id
   instance_id = module.ec2.instance-id
   public_subnet = [module.vpc.subnet_id,module.vpc.subnet_id-2]
}
