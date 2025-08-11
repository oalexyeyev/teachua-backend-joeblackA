# Basic GCP configuration
variable "gcp_project" {
  type        = string
  description = "GCP Project ID"
}

variable "gcp_region" {
  type        = string
  description = "GCP region"
}

variable "gcp_credentials_file" {
  type        = string
  description = "Path to GCP service account JSON key"
}

# Database credentials
variable "db_username" {
  type        = string
  description = "Database master username"
}

variable "db_password" {
  type        = string
  description = "Database master password"
  sensitive   = true
}
