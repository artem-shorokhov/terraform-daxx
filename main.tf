terraform {
  backend "gcs" {
    bucket = "company-terraform"
    prefix = "sonarqube-proxy"
  }
}

provider "google" {
  project = "${var.project}"
  version = "~> 2.6"
}

resource "google_compute_address" "external_static_ip" {
  name = "${var.google_compute_address_name}"
  region = "${var.region}"
}

resource "google_compute_instance" "sonarqube_proxy" {
  name = "${var.google_compute_instance_name}"
  machine_type = "${var.google_compute_instance_machine_type}"
  zone         = "${var.google_compute_instance_zone}"

  tags = "${var.google_compute_instance_tags}"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "${var.google_compute_instance_network}"

    access_config {
      nat_ip       = "${google_compute_address.external_static_ip.address}"
      network_tier = "STANDARD"
    }
  }

  metadata_startup_script = <<SCRIPT
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j DNAT --to-destination ${var.sonarqube_server_ip}:443
    iptables -A FORWARD -p tcp -d ${var.sonarqube_server_ip} --dport 443 -j ACCEPT
    iptables -A POSTROUTING -t nat -j MASQUERADE
  SCRIPT

  depends_on = ["google_compute_address.external_static_ip"]
}

resource "google_compute_firewall" "sonarqube_firewall" {
  name    = "${var.google_compute_firewall_name}"
  network = "${var.google_compute_instance_network}"

  source_ranges = "${var.google_compute_firewall_source_ranges}"

  target_tags = "${var.google_compute_instance_tags}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }
}
