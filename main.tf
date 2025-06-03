#####################################
# AWS NETWORK
#####################################
module "aws_network" {
  source          = "./modules/aws_network"
  vpc_cidr        = var.aws_vpc_cidr
  public_subnets  = var.aws_public_subnets
  private_subnets = var.aws_private_subnets
  region          = var.aws_region
  tags            = { Provider = "AWS" }
}

#####################################
# AZURE NETWORK
#####################################
module "azure_network" {
  source           = "./modules/azure_network"
  vnet_cidr        = var.azure_vnet_cidr
  subnet_cidrs     = var.azure_subnet_cidrs
  location         = var.azure_location
  resource_group   = var.azure_resource_group
  tags             = { Provider = "Azure" }
}

#####################################
# GCP NETWORK
#####################################
module "gcp_network" {
  source         = "./modules/gcp_network"
  vpc_cidr       = var.gcp_vpc_cidr
  subnet_cidrs   = var.gcp_subnet_cidrs
  region         = var.gcp_region
  project        = var.gcp_project
  tags           = { Provider = "GCP" }
}

#####################################
# VPN AWS <-> AZURE
#####################################
module "vpn_aws_azure" {
  source             = "./modules/vpn_aws_azure"
  vpc_id             = module.aws_network.vpc_id
  azure_gateway_ip   = module.azure_network.vpn_gateway_public_ip
  azure_vnet_cidr    = [var.azure_vnet_cidr]
  azure_bgp_asn      = var.azure_bgp_asn
  aws_bgp_asn        = var.aws_bgp_asn
  shared_secret      = var.aws_azure_shared_secret
}

module "vpn_azure_aws" {
  source                = "./modules/vpn_azure_aws"
  resource_group_name   = var.azure_resource_group
  location              = var.azure_location
  azure_vnet_gateway_id = module.azure_network.vnet_gateway_id
  aws_gateway_ip        = module.vpn_aws_azure.vpn_gateway_public_ip
  aws_vpc_cidr          = [var.aws_vpc_cidr]
  aws_bgp_asn           = var.aws_bgp_asn
  azure_bgp_asn         = var.azure_bgp_asn
  shared_secret         = var.aws_azure_shared_secret
}

#####################################
# VPN AWS <-> GCP
#####################################
module "vpn_aws_gcp" {
  source                  = "./modules/vpn_aws_gcp"
  vpc_id                  = module.aws_network.vpc_id
  remote_gcp_gateway_ip   = module.gcp_network.vpn_gateway_public_ip
  remote_gcp_bgp_asn      = var.gcp_bgp_asn
  local_bgp_asn           = var.aws_bgp_asn
  shared_secret           = var.aws_gcp_shared_secret
}

module "vpn_gcp_aws" {
  source            = "./modules/vpn_gcp_aws"
  network           = module.gcp_network.network_id
  region            = var.gcp_region
  peer_gateway_ip   = module.vpn_aws_gcp.vpn_gateway_public_ip
  shared_secret     = var.aws_gcp_shared_secret
  peer_bgp_asn      = var.aws_bgp_asn
  local_bgp_asn     = var.gcp_bgp_asn
}
