resource "aws_vpn_gateway" "this" {
  vpc_id = var.vpc_id
  tags = { Name = "aws-to-azure-vpn-gateway" }
}

resource "aws_customer_gateway" "azure" {
  bgp_asn    = var.azure_bgp_asn
  ip_address = var.azure_gateway_ip
  type       = "ipsec.1"
  tags = { Name = "azure-customer-gateway" }
}

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.azure.id
  type                = "ipsec.1"
  static_routes_only  = false

  tunnel1_preshared_key = var.shared_secret
  tunnel2_preshared_key = var.shared_secret

  # Kustomisasi CIDR dan BGP sesuai kebutuhan
  # static_routes_only true jika routing manual, biasanya false untuk BGP
}
