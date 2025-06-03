output "gcp_vpn_gateway_ip" {
  value = google_compute_vpn_gateway.this.self_link
}
output "gcp_vpn_gateway_id" {
  value = google_compute_vpn_gateway.this.id
}
