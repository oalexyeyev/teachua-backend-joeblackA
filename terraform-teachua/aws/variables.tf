variable "bastion_allowed_cidr" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "aws_az" {
  description = "AWS Availability Zone to place all resources in"
  type        = string
  default     = "us-east-1a"
}

variable "aws_az_2" {
  description = "AWS Availability Zone to place all resources in"
  type        = string
  default     = "us-east-1b"
}
