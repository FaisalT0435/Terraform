output "org_id" {
  value = aws_organizations_organization.this.id
}
output "root_id" {
  value = aws_organizations_organization.this.roots[0].id
}
output "ou_ids" {
  value = merge(
    { for k, v in aws_organizations_organizational_unit.ou : k => v.id },
    { for k, v in aws_organizations_organizational_unit.sub_ou : k => v.id }
  )
}
output "account_ids" {
  value = { for k, v in aws_organizations_account.account : k => v.id }
}
