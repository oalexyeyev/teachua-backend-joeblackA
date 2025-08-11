module "network" {
  source = "./modules/network"
  gcp_region = var.gcp_region
}

module "instances" {
  source     = "./modules/instances"
  gcp_region = var.gcp_region

  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}

module "sql" {
  source      = "./modules/sql"
  gcp_region  = var.gcp_region
  network_id  = module.network.network_id
  db_username = var.db_username
  db_password = var.db_password
}
