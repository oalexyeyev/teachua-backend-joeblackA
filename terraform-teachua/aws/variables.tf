variable "bastion_ami" {
  description = "AMI ID for bastion"
  type        = string
  default     = "ami-0de716d6197524dd9"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion"
  type        = string
  default     = "t2.micro"
}

variable "backend_ami" {
  description = "AMI ID for backend"
  type        = string
  default     = "ami-0de716d6197524dd9"
}

variable "backend_instance_type" {
  description = "Instance type for backend"
  type        = string
  default     = "t2.micro"
}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.3.0/24"
}


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
