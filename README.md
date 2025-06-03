# 🌐 Multi-Cloud Site-to-Site VPN Terraform Modules

Deploy secure, production-grade VPN interconnect between **AWS, Azure, and GCP** with simple, reusable modules.  
Automate networking for hybrid/multi-cloud and ensure your workloads communicate securely across all environments!

---

## 📂 Directory Structure

```
.
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── provider.tf
└── modules/
    ├── aws_network/
    ├── azure_network/
    ├── gcp_network/
    ├── vpn_aws_azure/
    ├── vpn_azure_aws/
    ├── vpn_aws_gcp/
    └── vpn_gcp_aws/
```

---

## 🚀 Quick Example: AWS ↔ Azure Site-to-Site VPN

### 1️⃣ **Prerequisites**
- AWS, Azure, and GCP credentials ready (`aws configure`, Azure service principal, GCP SA key or ADC)
- Network modules provide VPC/VNet IDs, VPN gateway public IPs, etc.

---

### 2️⃣ **Sample Usage in `main.tf`**

```hcl
# AWS Network
module "aws_network" {
  source          = "./modules/aws_network"
  vpc_cidr        = var.aws_vpc_cidr
  public_subnets  = var.aws_public_subnets
  private_subnets = var.aws_private_subnets
  region          = var.aws_region
}

# Azure Network
module "azure_network" {
  source           = "./modules/azure_network"
  vnet_cidr        = var.azure_vnet_cidr
  subnet_cidrs     = var.azure_subnet_cidrs
  location         = var.azure_location
  resource_group   = var.azure_resource_group
}

# AWS → Azure VPN
module "vpn_aws_azure" {
  source             = "./modules/vpn_aws_azure"
  vpc_id             = module.aws_network.vpc_id
  azure_gateway_ip   = module.azure_network.vpn_gateway_public_ip
  azure_vnet_cidr    = [var.azure_vnet_cidr]
  azure_bgp_asn      = var.azure_bgp_asn
  aws_bgp_asn        = var.aws_bgp_asn
  shared_secret      = var.aws_azure_shared_secret
}

# Azure → AWS VPN
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
```

---

### 3️⃣ **Variables: `variables.tf` Example**

```hcl
variable "aws_region" {}
variable "aws_vpc_cidr" {}
variable "aws_public_subnets" { type = list(string) }
variable "aws_private_subnets" { type = list(string) }
variable "aws_bgp_asn" {}
variable "aws_azure_shared_secret" {}

variable "azure_location" {}
variable "azure_resource_group" {}
variable "azure_vnet_cidr" {}
variable "azure_subnet_cidrs" { type = list(string) }
variable "azure_bgp_asn" {}
```

---

### 4️⃣ **terraform.tfvars Example**

```hcl
aws_region          = "ap-southeast-1"
aws_vpc_cidr        = "10.10.0.0/16"
aws_public_subnets  = ["10.10.1.0/24"]
aws_private_subnets = ["10.10.10.0/24"]
aws_bgp_asn         = 65010
aws_azure_shared_secret = "AwsAzureSecret123"

azure_location         = "southeastasia"
azure_resource_group   = "multicloud-demo"
azure_vnet_cidr        = "10.20.0.0/16"
azure_subnet_cidrs     = ["10.20.1.0/24"]
azure_bgp_asn          = 65020
```

---

### 5️⃣ **Outputs**

After running `terraform apply`, you will get outputs like:

```
Outputs:

vpn_aws_azure_vpn_gateway_public_ip = "52.x.x.x"
vpn_azure_aws_connection_id         = "/subscriptions/xxxx/resourceGroups/..."
```
Use these for troubleshooting or reference.

---

## 🌏 Add AWS ↔ GCP? Easy!

The pattern is the same.  
Just add and wire up:

```hcl
module "vpn_aws_gcp" {
  source                = "./modules/vpn_aws_gcp"
  vpc_id                = module.aws_network.vpc_id
  remote_gcp_gateway_ip = module.gcp_network.vpn_gateway_public_ip
  remote_gcp_bgp_asn    = var.gcp_bgp_asn
  local_bgp_asn         = var.aws_bgp_asn
  shared_secret         = var.aws_gcp_shared_secret
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
```

---

## 🛡️ How It Works

- Each side (AWS, Azure, GCP) deploys VPN Gateway and S2S resource.
- Pre-shared key, ASN, and CIDRs must match across both sides.
- Each provider’s output (public IP, ASN) is passed as input to the other.
- Don't forget to update route tables and allow traffic in NSG/SG/firewall!

---

## 🛠️ Tips

- Use the same shared secret and consistent ASN on both sides.
- Use `terraform output` to see available outputs.
- Need full mesh (AWS ↔ Azure ↔ GCP)? Just extend the same pattern.

---

## 📚 References

- [AWS Site-to-Site VPN Docs](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html)
- [Azure VPN Gateway Docs](https://docs.microsoft.com/en-us/azure/vpn-gateway/)
- [GCP Cloud VPN Docs](https://cloud.google.com/network-connectivity/docs/vpn)

---

## 🤔 FAQ

**Q: Why is my output red/error?**  
A: Make sure every module’s `outputs.tf` exports the values used in the root `main.tf`!

**Q: Can I automate for more than two clouds?**  
A: Yes! Just add more modules and cross-reference outputs.

---

Happy Hybrid Networking! 🚀