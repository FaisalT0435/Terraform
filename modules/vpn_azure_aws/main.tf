resource "azurerm_local_network_gateway" "aws" {
  name                = "aws-local-gw"
  resource_group_name = var.resource_group_name
  location            = var.location
  gateway_address     = var.aws_gateway_ip
  address_space       = var.aws_vpc_cidr
  bgp_settings {
    asn                 = var.aws_bgp_asn
    bgp_peering_address = var.aws_gateway_ip
  }
}

resource "azurerm_virtual_network_gateway_connection" "aws_conn" {
  name                       = "azure-to-aws-vpn"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  virtual_network_gateway_id = var.azure_vnet_gateway_id
  type                       = "IPsec"
  shared_key                 = var.shared_secret
  connection_protocol        = "IKEv2"
  local_network_gateway_id   = azurerm_local_network_gateway.aws.id
  enable_bgp                 = true
}
