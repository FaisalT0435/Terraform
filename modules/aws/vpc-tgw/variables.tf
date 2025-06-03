variable "vpc_name" { type = string }
variable "cidr" { type = string }
variable "azs" { type = list(string) }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "tags" { type = map(string) }
variable "customer_gateway_ip" { type = string }
variable "customer_gateway_bgp_asn" { type = string }
variable "vpn_psk" { type = string }
variable "enable_vpc_flow_log" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_traffic_type" {
  description = "Traffic type for VPC Flow Logs"
  type        = string
  default     = "ALL"
}

variable "flow_log_retention_in_days" {
  description = "Retention days for CloudWatch log group"
  type        = number
  default     = 30
}

variable "flow_log_log_group_name" {
  description = "Name of the CloudWatch Log Group for VPC Flow Logs"
  type        = string
  default     = "/vpc/flowlogs"
}

