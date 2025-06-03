output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets" {
  value = module.vpc.public_subnets
}
output "private_subnets" {
  value = module.vpc.private_subnets
}
output "tgw_id" {
  value = aws_ec2_transit_gateway.this.id
}
output "firewall_arn" {
  value = aws_networkfirewall_firewall.this.arn
}
output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}
output "vpc_flowlog_id" {
  description = "ID of the VPC Flow Log"
  value       = aws_flow_log.this[*].id
}

output "vpc_flowlog_log_group_name" {
  value = aws_cloudwatch_log_group.vpc_flow.name
}
