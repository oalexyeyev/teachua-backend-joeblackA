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

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id       = module.network.vpc_id
  bastion_cidr = var.bastion_allowed_cidr
}

module "instances" {
  source = "./modules/instances"

  key_pair_name     = var.key_pair_name
  bastion_sg_id     = module.security_groups.bastion_sg_id
  backend_sg_id     = module.security_groups.backend_sg_id
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}

# module "secrets_manager" {
#   source             = "./modules/secrets_manager"
#   secret_name        = "teachua-db-password"
#   secret_description = "RDS password for TeachUA project"
#   secret_string      = var.db_password
# }

module "rds" {
  source = "./modules/rds"

  db_username   = var.db_username
  db_password   = var.db_password
  db_subnet_ids = [module.network.private_subnet_id, module.network.public_subnet_id]
  db_sg_id      = module.security_groups.db_sg_id
}

data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
