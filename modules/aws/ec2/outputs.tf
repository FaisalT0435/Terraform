output "public_ip" {
  value = aws_instance.this[*].public_ip
}
output "public_dns" {
  value = aws_instance.this[*].public_dns
}
output "id" {
  value = aws_instance.this[*].id
}
output "iam_role_name" {
  value = aws_iam_role.cw_agent.name
}
output "iam_instance_profile" {
  value = aws_iam_instance_profile.cw_agent_profile.name
}
