output "connection_id" {
  value = azurerm_virtual_network_gateway_connection.aws_conn.id
}

output "local_network_gateway_id" {
  value = azurerm_local_network_gateway.aws.id
}
