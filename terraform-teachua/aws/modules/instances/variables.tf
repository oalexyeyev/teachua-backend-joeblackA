variable "bastion_ami" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}


variable "backend_ami" {
  description = "AMI ID for the backend host"
  type        = string
}

variable "backend_instance_type" {
  description = "Instance type for the backend host"
  type        = string
}


variable "public_subnet_id" {
  description = "Public subnet ID for the bastion host"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for the backend host"
  type        = string
}

variable "key_pair_name" {
  description = "SSH key pair name to use for both instances"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  type        = string
}

variable "backend_sg_id" {
  description = "Security group ID for the backend host"
  type        = string
}
