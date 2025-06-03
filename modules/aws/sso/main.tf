data "aws_ssoadmin_instances" "all" {}
locals {
  sso_instance_arn = data.aws_ssoadmin_instances.all.arns[0]
}

# Create SSO groups
resource "aws_identitystore_group" "groups" {
  for_each      = toset(var.groups)
  identity_store_id = data.aws_ssoadmin_instances.all.identity_store_ids[0]
  display_name  = each.value
  description   = "${each.value} group"
}

# Create SSO users, add to group
resource "aws_identitystore_user" "users" {
  for_each = { for user in var.users : user.username => user }
  identity_store_id = data.aws_ssoadmin_instances.all.identity_store_ids[0]
  user_name    = each.value.username
  display_name = "${each.value.first_name} ${each.value.last_name}"
  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }
  emails {
    value = each.value.email
    primary = true
  }
}

resource "aws_identitystore_group_membership" "user_groups" {
  for_each = { for user in var.users : user.username => user if user.group != "" }
  identity_store_id = data.aws_ssoadmin_instances.all.identity_store_ids[0]
  group_id = aws_identitystore_group.groups[each.value.group].group_id
  member_id = aws_identitystore_user.users[each.value.username].user_id
}

# Create Permission Sets (role templates)
resource "aws_ssoadmin_permission_set" "psets" {
  for_each     = { for p in var.permission_sets : p.name => p }
  instance_arn = local.sso_instance_arn
  name         = each.value.name
  description  = each.value.description
  managed_policies = each.value.managed_policies
}

# Assign Permission Set to Users/Groups on Target Accounts
resource "aws_ssoadmin_account_assignment" "assignments" {
  for_each = {
    for aa in var.account_assignments :
    "${aa.principal_type}:${aa.principal_name}:${aa.account_id}:${aa.permission_set_name}" => aa
  }
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.psets[each.value.permission_set_name].arn
  principal_type     = each.value.principal_type
  principal_id       = (
    each.value.principal_type == "USER"
    ? aws_identitystore_user.users[each.value.principal_name].user_id
    : aws_identitystore_group.groups[each.value.principal_name].group_id
  )
  target_id          = each.value.account_id
  target_type        = "AWS_ACCOUNT"
}


#########################
#untuk menggunakan root main.tf 

# module "sso" {
#   source = "./modules/sso"
#   users = [
#     { username = "hd", email = "hd@example.com", first_name = "HD", last_name = "SDSD", group = "DevOps" },
#     { username = "dev", email = "dev@example.com", first_name = "Dev", last_name = "Account", group = "Developer" }
#   ]
#   groups = ["DevOps", "Developer"]
#   permission_sets = [
#     {
#       name = "AdministratorAccess"
#       description = "Admin full access"
#       managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
#     },
#     {
#       name = "ReadOnly"
#       description = "Read only access"
#       managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
#     }
#   ]
#   account_assignments = [
#     {
#       principal_type = "USER"
#       principal_name = "hd"
#       account_id = "123456789012"
#       permission_set_name = "AdministratorAccess"
#     },
#     {
#       principal_type = "GROUP"
#       principal_name = "Developer"
#       account_id = "123456789013"
#       permission_set_name = "ReadOnly"
#     }
#   ]
# }
