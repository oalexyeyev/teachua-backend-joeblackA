resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]

  depends_on = [google_compute_global_address.private_ip_alloc]
}

resource "google_sql_database_instance" "mariadb" {
  name             = "teachua-db"
  database_version = "MYSQL_8_0"
  region           = var.gcp_region
  deletion_protection = false
  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "default" {
  name     = "teachua"
  instance = google_sql_database_instance.mariadb.name
}

resource "google_sql_user" "default" {
  name     = var.db_username
  instance = google_sql_database_instance.mariadb.name
  password = var.db_password
}

output "db_private_ip" {
  value = google_sql_database_instance.mariadb.private_ip_address
}
