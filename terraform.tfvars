aws_region          = "ap-southeast-1"
aws_vpc_cidr        = "10.10.0.0/16"
aws_public_subnets  = ["10.10.1.0/24"]
aws_private_subnets = ["10.10.10.0/24"]
aws_bgp_asn         = 65010
aws_azure_shared_secret = "AwsAzureSharedSecret123"
aws_gcp_shared_secret   = "AwsGcpSharedSecret123"

azure_subscription_id  = "xxxx-xxxx-xxxx-xxxx"
azure_client_id        = "xxxxxxxxxxxxxxxxxxxx"
azure_client_secret    = "xxxxxxxxxxxxxxxxxxxx"
azure_tenant_id        = "xxxxxxxxxxxxxxxxxxxx"
azure_location         = "southeastasia"
azure_resource_group   = "cloud-multinet"
azure_vnet_cidr        = "10.20.0.0/16"
azure_subnet_cidrs     = ["10.20.1.0/24"]
azure_bgp_asn          = 65020
azure_shared_secret    = "AwsAzureSharedSecret123"

gcp_project            = "my-gcp-project"
gcp_region             = "asia-southeast1"
gcp_vpc_cidr           = "10.30.0.0/16"
gcp_subnet_cidrs       = ["10.30.1.0/24"]
gcp_bgp_asn            = 65030
gcp_shared_secret      = "AwsGcpSharedSecret123"
