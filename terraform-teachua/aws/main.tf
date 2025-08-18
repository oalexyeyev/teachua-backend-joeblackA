terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  aws_az               = var.aws_az
  aws_az_2             = var.aws_az_2
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id       = module.network.vpc_id
  bastion_cidr = var.bastion_allowed_cidr
}

module "instances" {
  source = "./modules/instances"
 # Bastion
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  bastion_sg_id     = module.security_groups.bastion_sg_id

  # Backend
  backend_ami           = var.backend_ami
  backend_instance_type = var.backend_instance_type
  backend_sg_id     = module.security_groups.backend_sg_id

  # Shared
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id

  key_pair_name     = var.key_pair_name
}

module "secrets_manager" {
  source             = "./modules/secrets_manager"
  secret_name        = "teachua-db-password"
  secret_description = "RDS password for TeachUA project"
  secret_string      = var.db_password
}

module "rds" {
  source = "./modules/rds"

  db_username = var.db_username
  db_password = var.db_password
  #db_subnet_ids = [module.network.private_subnet_id, module.network.public_subnet_id]

# Use both private subnets (diff AZs) to satisfy AWS requirement
  db_subnet_ids = [
    module.network.private_subnet_id,
    module.network.private_rds_dummy_subnet_id]
  db_sg_id      = module.security_groups.db_sg_id
}

data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
