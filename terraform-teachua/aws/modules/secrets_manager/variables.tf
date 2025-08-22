variable "secret_name" {
  type = string
}

variable "secret_description" {
  type = string
}

variable "secret_string" {
  type      = string
  sensitive = true
}
