output "permission_sets" {
  value = { for k,v in aws_ssoadmin_permission_set.psets : k => v.arn }
}
output "users" {
  value = { for k,v in aws_identitystore_user.users : k => v.user_id }
}
output "groups" {
  value = { for k,v in aws_identitystore_group.groups : k => v.group_id }
}
