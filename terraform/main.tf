terraform {
  required_version = "<1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
  profile = "k8s-test-project"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-test-vpc"
  cidr = "10.0.0.0/16"

  azs             = [ "eu-north-1a", "eu-north-1b", "eu-north-1c" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  map_public_ip_on_launch = true
  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = local.env_tags
}

module "rds" {
  source = "../modules/rds"
  rds-subnet_ids = module.vpc.private_subnets
  rds-vpc-security-group-ids = module.vpc.default_vpc_default_security_group_id
  rds-instance-name = "${local.stack_name}-rds"
}

module "eks" {
  source = "../modules/eks"
  cluster_name = "test-cluster"
  
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  self_managed_node_groups_name = "learning"
}