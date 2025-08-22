terraform {
  backend "s3" {
    bucket       = "teachua-terraform1"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    profile      = "terraform-tfstate"
    encrypt      = true
    use_lockfile = true # instead of dynamodb_table
  }
}
