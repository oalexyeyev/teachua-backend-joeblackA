#output "bastion_public_ip" {
#  description = "Public IP of bastion host"
#  value       = length(module.aws) > 0 ? module.aws[0].bastion_public_ip : ""
#}

#output "backend_private_ip" {
# description = "Private IP of backend server"
# value       = length(module.aws) > 0 ? module.aws[0].backend_private_ip : ""
#}

#output "database_endpoint" {
#  description = "RDS database endpoint"
#value       = length(module.aws) > 0 ? module.aws[0].database_endpoint : ""
#}
