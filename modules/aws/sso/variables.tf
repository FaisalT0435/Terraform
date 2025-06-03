variable "users" {
  description = "SSO users"
  type = list(object({
    username  = string
    email     = string
    first_name = string
    last_name  = string
    group     = string
  }))
}

variable "groups" {
  description = "SSO groups"
  type = list(string)
}

variable "permission_sets" {
  description = "List of permission sets to create"
  type = list(object({
    name        = string
    description = string
    managed_policies = list(string)
    # optionally: inline_policy_json, session_duration, dsb
  }))
}

variable "account_assignments" {
  description = "List of assignment: user/group, account, permission set"
  type = list(object({
    principal_type    = string # "USER" or "GROUP"
    principal_name    = string
    account_id        = string
    permission_set_name = string
  }))
}

# If you want, pass sso_instance_arn from root module
