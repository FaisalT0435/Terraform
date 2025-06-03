resource "google_compute_router" "this" {
  name    = "gcp-to-aws-router"
  region  = var.region
  network = var.network
  bgp {
    asn = var.local_bgp_asn
  }
}

resource "google_compute_vpn_gateway" "this" {
  name    = "gcp-to-aws-vpn-gw"
  region  = var.region
  network = var.network
}

resource "google_compute_vpn_tunnel" "this" {
  name          = "gcp-to-aws-tunnel"
  region        = var.region
  vpn_gateway   = google_compute_vpn_gateway.this.id
  peer_ip       = var.peer_gateway_ip
  shared_secret = var.shared_secret
  router        = google_compute_router.this.id
  ike_version   = 2
  # Tambahkan BGP dan route sesuai kebutuhan
}
