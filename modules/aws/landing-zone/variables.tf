variable "master_account_email" { type = string }
variable "ou_structure" {
  description = "List of OUs and sub-OUs for the landing zone"
  type = any
}
variable "accounts" {
  description = "List of accounts with their OU path and email"
  type = list(object({
    name    = string
    email   = string
    ou_path = list(string)
    tags    = map(string)
  }))
}
variable "org_features" {
  description = "Set feature_set of the org"
  type        = string
  default     = "ALL"
}
