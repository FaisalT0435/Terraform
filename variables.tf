# AWS
variable "aws_region" { type = string }
variable "aws_vpc_cidr" { type = string }
variable "aws_public_subnets" { type = list(string) }
variable "aws_private_subnets" { type = list(string) }
variable "aws_bgp_asn" { type = number }
variable "aws_azure_shared_secret" { type = string }
variable "aws_gcp_shared_secret" { type = string }

# Azure
variable "azure_subscription_id" { type = string }
variable "azure_client_id" { type = string }
variable "azure_client_secret" { type = string }
variable "azure_tenant_id" { type = string }
variable "azure_location" { type = string }
variable "azure_resource_group" { type = string }
variable "azure_vnet_cidr" { type = string }
variable "azure_subnet_cidrs" { type = list(string) }
variable "azure_bgp_asn" { type = number }
variable "azure_shared_secret" { type = string }

# GCP
variable "gcp_project" { type = string }
variable "gcp_region" { type = string }
variable "gcp_vpc_cidr" { type = string }
variable "gcp_subnet_cidrs" { type = list(string) }
variable "gcp_bgp_asn" { type = number }
variable "gcp_shared_secret" { type = string }
