resource "aws_organizations_organization" "this" {
  feature_set = var.org_features
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
    "guardduty.amazonaws.com",
    "account.amazonaws.com"
  ]
}

# Recursive creation of OUs (simplified, can be expanded for deeper nesting)
# Example ou_structure: [
#   { name = "Infra",  parent_id = null },
#   { name = "Network", parent_id = "Infra" },
#   { name = "Backup", parent_id = "Infra" },
#   { name = "Security", parent_id = "Infra" },
#   { name = "Management", parent_id = "Infra" },
#   { name = "Audit", parent_id = "Infra" },
#   { name = "Develop", parent_id = null },
#   { name = "App1 Dev", parent_id = "Develop" },
#   ...
# ]

locals {
  ou_map = {
    for idx, ou in var.ou_structure :
    ou.name => {
      idx       = idx
      name      = ou.name
      parent_id = ou.parent_id
    }
  }
}

# Build root and top-level OUs
resource "aws_organizations_organizational_unit" "ou" {
  for_each = { for ou in var.ou_structure : ou.name => ou if ou.parent_id == null }
  name     = each.value.name
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Build sub-OUs (1 level nested)
resource "aws_organizations_organizational_unit" "sub_ou" {
  for_each = { for ou in var.ou_structure : ou.name => ou if ou.parent_id != null }
  name     = each.value.name
  parent_id = try(
    aws_organizations_organizational_unit.ou[each.value.parent_id].id,
    aws_organizations_organizational_unit.sub_ou[each.value.parent_id].id
  )
}

# Create accounts and place them in the right OU
resource "aws_organizations_account" "account" {
  for_each = { for acct in var.accounts : acct.name => acct }
  name     = each.value.name
  email    = each.value.email
  parent_id = try(
    aws_organizations_organizational_unit.ou[each.value.ou_path[0]].id,
    aws_organizations_organizational_unit.sub_ou[each.value.ou_path[0]].id
  )
  tags = merge({
    "ProvisionedBy" = "Terraform"
  }, each.value.tags)
}

# Untuk panggill di mroot main.tf 

#################################################
# module "landing_zone" {
#   source = "./modules/landing_zone"
#   master_account_email = "master@yourcompany.com"
#   org_features = "ALL"
#   ou_structure = [
#     { name = "Infra",    parent_id = null },
#     { name = "Network",  parent_id = "Infra" },
#     { name = "Backup",   parent_id = "Infra" },
#     { name = "Security", parent_id = "Infra" },
#     { name = "Management", parent_id = "Infra" },
#     { name = "Audit",    parent_id = "Infra" },
#     { name = "Develop",  parent_id = null },
#     { name = "App1 Dev", parent_id = "Develop" },
#     { name = "App2 Dev", parent_id = "Develop" },
#     { name = "Data Dev", parent_id = "Develop" },
#     { name = "Prod",     parent_id = null },
#     { name = "App1 Prod", parent_id = "Prod" },
#     { name = "App2 Prod", parent_id = "Prod" },
#     { name = "Data Prod", parent_id = "Prod" }
#   ]
#   accounts = [
#     {
#       name    = "network-account"
#       email   = "network@yourcompany.com"
#       ou_path = ["Network"]
#       tags    = { Env = "infra" }
#     },
#     {
#       name    = "backup-account"
#       email   = "backup@yourcompany.com"
#       ou_path = ["Backup"]
#       tags    = { Env = "infra" }
#     },
#     # ... tambahkan sesuai kebutuhan
#   ]
# }
