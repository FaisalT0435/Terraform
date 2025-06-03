output "aws_vpc_id" {
  value = module.aws_network.vpc_id
}
output "aws_vpn_gateway_public_ip" {
  value = module.aws_network.vpn_gateway_public_ip
}

output "azure_vnet_id" {
  value = module.azure_network.vnet_id
}
output "azure_vpn_gateway_public_ip" {
  value = module.azure_network.vpn_gateway_public_ip
}

output "gcp_network_id" {
  value = module.gcp_network.network_id
}
output "gcp_vpn_gateway_public_ip" {
  value = module.gcp_network.vpn_gateway_public_ip
}

output "vpn_aws_gcp_id" {
  value = module.vpn_aws_gcp.vpn_connection_id
}
output "vpn_aws_azure_id" {
  value = module.vpn_aws_azure.vpn_connection_id
}
