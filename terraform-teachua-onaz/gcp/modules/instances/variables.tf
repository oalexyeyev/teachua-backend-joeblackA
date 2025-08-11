variable "gcp_region" {
  type        = string
  description = "Region for instances"
}

variable "public_subnet_id" {
  type        = string
  description = "Subnet ID for bastion host"
}

variable "private_subnet_id" {
  type        = string
  description = "Subnet ID for backend host"
}
