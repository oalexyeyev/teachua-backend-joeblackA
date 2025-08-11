variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "aws_az" {
  type = string
}

variable "aws_az_2" {
  type = string
  default = "us-east-1b"
}

variable "private_subnet_cidr_2" {
  type    = string
  default = "10.0.3.0/24"
}
