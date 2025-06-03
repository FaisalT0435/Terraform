variable "vpc_id" { type = string }
variable "azure_gateway_ip" { type = string }
variable "azure_vnet_cidr" { type = list(string) } # CIDR dari Azure VNet
variable "azure_bgp_asn" { type = number }
variable "aws_bgp_asn" { type = number }
variable "shared_secret" { type = string }
