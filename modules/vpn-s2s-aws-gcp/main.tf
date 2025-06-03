resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id
  tags = { Name = "aws-to-gcp-vpn-gateway" }
}

resource "aws_customer_gateway" "gcp" {
  bgp_asn    = var.remote_gcp_bgp_asn
  ip_address = var.remote_gcp_gateway_ip
  type       = "ipsec.1"
  tags = { Name = "gcp-customer-gateway" }
}

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.gcp.id
  type                = "ipsec.1"
  static_routes_only  = false
  tunnel1_preshared_key = var.shared_secret
  tunnel2_preshared_key = var.shared_secret
}
