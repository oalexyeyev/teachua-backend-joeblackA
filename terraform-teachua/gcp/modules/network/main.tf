resource "google_compute_network" "main" {
  name                    = "teachua-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.main.id
}

resource "google_compute_subnetwork" "private" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.gcp_region
  network       = google_compute_network.main.id
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.main.id
  region  = var.gcp_region
}

resource "google_compute_router_nat" "nat_config" {
  name                               = "nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


# Firewall rules
resource "google_compute_firewall" "allow_ssh_bastion" {
  name    = "allow-ssh-bastion"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

resource "google_compute_firewall" "allow_backend_from_bastion" {
  name    = "allow-backend"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_tags = ["bastion"]
  target_tags = ["backend"]
}


resource "google_compute_firewall" "allow_http_bastion" {
  name    = "allow-http-bastion"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}



# Allow SSH from bastion to backend
resource "google_compute_firewall" "allow_ssh_backend_from_bastion" {
  name    = "allow-ssh-backend-from-bastion"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastion"]
  target_tags = ["backend"]
}

output "public_subnet_id" {
  value = google_compute_subnetwork.public.id
}

output "private_subnet_id" {
  value = google_compute_subnetwork.private.id
}


output "network_id" {
  value = google_compute_network.main.id
}
