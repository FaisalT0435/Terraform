output "vpn_gateway_id" {
  value = aws_vpn_gateway.this.id
}

output "vpn_gateway_public_ip" {
  value = aws_vpn_gateway.this.public_ip
}

output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}
