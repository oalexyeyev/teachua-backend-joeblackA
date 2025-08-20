variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "bastion_cidr" {
  type        = string
  description = "CIDR allowed to access the bastion host via SSH"
  default     = "0.0.0.0/0"
}

variable "ssh_port" {
  type        = number
  description = "SSH port"
  default     = 22
}

variable "app_port" {
  type        = number
  description = "Backend application port"
  default     = 8080
}

variable "db_port" {
  type        = number
  description = "Database port"
  default     = 3306
}

variable "squid_port" {
  type        = number
  description = "Squid proxy port"
  default     = 3128
}

variable "backend_cidr" {
  type        = string
  description = "CIDR of backend network for Squid or internal traffic"
  default     = "10.0.0.0/16"
}

variable "prometheus_port" {
  default = 9090
}

variable "grafana_port" {
  default = 3000
}

variable "node_exporter_port" {
  default = 9100
}
