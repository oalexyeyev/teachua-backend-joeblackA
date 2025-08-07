output "bastion_public_ip" {
  value = module.instances.bastion_public_ip
}

output "backend_private_ip" {
  value = module.instances.backend_private_ip
}

output "database_endpoint" {
  value = module.rds.db_endpoint
}
