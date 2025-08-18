variable "cloud" {
  description = "Choose cloud: aws or gcp"
  type        = string
  default     = "aws"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "sandbox"
}

variable "key_pair_name" {
  type        = string
  description = "Existing EC2 KeyPair name"
}

variable "db_username" {
  type        = string
  default     = "teachua_user"
  description = "Database master username"
}

variable "db_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
  default     = null
}

variable "bastion_allowed_cidr" {
  type        = string
  default     = "0.0.0.0/0" # Рекомендую замінити на свій IP
  description = "CIDR для доступу до Bastion SSH"
}

variable "assume_role_arn" {
  type      = string
  sensitive = true
}

#variable "gcp_project" {
# type = string
#}

#variable "gcp_region" {
# type    = string
#default = "us-central1"
#}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

#variable "gcp_credentials_file" {
# description = "Path to the GCP service account key file"
#type        = string
#}
