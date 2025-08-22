
# AWS Profile Auth
#variable "aws_profile" {
# description = "AWS CLI profile to use"
#type        = string
#default     = "terraform-user"
#}

#provider "aws" {
# region  = var.aws_region
#profile = var.aws_profile
#assume_role {
# role_arn = "arn:aws:iam::135424146100:role/TerraformExecutionRole"
#}
#alias = "aws"
#}


#provider "google" {
#  project     = var.gcp_project
#  region      = var.gcp_region
#  credentials = file(var.gcp_credentials_file)
#}
