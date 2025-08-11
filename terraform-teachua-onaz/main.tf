terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    # Add gcp here if needed
    #    google = {
    #      source  = "hashicorp/google"
    #      version = "~> 6.0"
    #    }


  }
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

output "generated_db_password" {
  value     = random_password.db_password.result
  sensitive = true
}



provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  assume_role {
    role_arn = "arn:aws:iam::135424146100:role/TerraformExecutionRole"
  }
}

module "aws" {
  source = "./aws"
  count  = var.cloud == "aws" ? 1 : 0

  bastion_allowed_cidr = var.bastion_allowed_cidr
  key_pair_name        = var.key_pair_name
  db_username          = var.db_username
  db_password          = random_password.db_password.result
  #var.db_password
}


# Optional: GCP module if you use multi-cloud
#module "gcp" {
# source = "./gcp"


#count                = var.cloud == "gcp" ? 1 : 0
#gcp_project          = var.gcp_project
#gcp_region           = var.gcp_region
#gcp_credentials_file = var.gcp_credentials_file
#db_username          = var.db_username
#db_password          = var.db_password


#}
