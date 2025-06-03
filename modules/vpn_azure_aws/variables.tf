variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "azure_vnet_gateway_id" { type = string }
variable "aws_gateway_ip" { type = string }
variable "aws_vpc_cidr" { type = list(string) }
variable "aws_bgp_asn" { type = number }
variable "azure_bgp_asn" { type = number }
variable "shared_secret" { type = string }
