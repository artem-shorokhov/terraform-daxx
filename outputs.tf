output "external_static_ip_address" {
  value       = "${google_compute_address.external_static_ip.address}"
  description = "External regional static IP address."
}
