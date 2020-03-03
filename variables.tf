variable "project" {
  default = "project"
}

variable "region" {
  default = "europe-west3"
}

variable "google_compute_address_name" {
  default = "sonarqube-proxy-static-ip"
}

variable "google_compute_instance_name" {
  default = "sonarqube-proxy-vm"
}

variable "google_compute_instance_machine_type" {
  default = "f1-micro"
}

variable "google_compute_instance_zone" {
  default = "europe-west3-b"
}

variable "google_compute_instance_tags" {
  default = ["sonarqube-proxy"]
  type    = "list"

}

variable "google_compute_instance_network" {
  default = "default"
}

variable "sonarqube_server_ip" {
  default     = "123.123.123.123"
  description = "IP address of https://sonarqube.domain.com"
}

variable "google_compute_firewall_name" {
  default = "sonarqube-proxy-fw"
}

variable "google_compute_firewall_source_ranges" {
  default     = ["0.0.0.0/0"]
  description = "Source IP ranges for Google Cloud Build. Could be restricted to known GCP addresses, but may change."
  type        = "list"
}
