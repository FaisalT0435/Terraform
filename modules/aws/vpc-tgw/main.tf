# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"
  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = var.azs
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge({
    "Terraform" = "true"
    "Module"    = "vpc"
  }, var.tags)
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description = "${var.vpc_name}-tgw"
  tags = merge({
    Name = "${var.vpc_name}-tgw"
  }, var.tags)
}

# TGW Attachment to VPC
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.vpc.vpc_id

  tags = merge({
    Name = "${var.vpc_name}-tgw-attachment"
  }, var.tags)
}

# Network Firewall (Firewall Endpoint)
resource "aws_networkfirewall_firewall_policy" "this" {
  name = "${var.vpc_name}-fw-policy"
  firewall_policy {
    stateless_default_actions = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_engine_options {
      rule_order = "DEFAULT_ACTION_ORDER"
    }
  }
}

resource "aws_networkfirewall_firewall" "this" {
  name              = "${var.vpc_name}-firewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id            = module.vpc.vpc_id
  subnet_mapping {
    subnet_id = module.vpc.public_subnets[0]
  }
  subnet_mapping {
    subnet_id = module.vpc.public_subnets[1]
  }
  delete_protection = false
  tags = merge({
    Name = "${var.vpc_name}-firewall"
  }, var.tags)
}

# VPN Site-to-Site
resource "aws_vpn_gateway" "this" {
  vpc_id = module.vpc.vpc_id
  tags = merge({
    Name = "${var.vpc_name}-vpn-gw"
  }, var.tags)
}

resource "aws_customer_gateway" "this" {
  bgp_asn    = var.customer_gateway_bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
  tags = merge({
    Name = "${var.vpc_name}-customer-gw"
  }, var.tags)
}

resource "aws_vpn_connection" "this" {
  vpn_gateway_id      = aws_vpn_gateway.this.id
  customer_gateway_id = aws_customer_gateway.this.id
  type                = "ipsec.1"
  static_routes_only  = false

  tunnel1_preshared_key = var.vpn_psk
  tunnel2_preshared_key = var.vpn_psk

  tags = merge({
    Name = "${var.vpc_name}-vpn"
  }, var.tags)
}
resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = var.flow_log_log_group_name
  retention_in_days = var.flow_log_retention_in_days
  kms_key_id        = null # bisa diganti KMS jika perlu
}

resource "aws_iam_role" "vpc_flowlog" {
  name = "${var.vpc_name}-vpc-flowlog-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role.json
}

data "aws_iam_policy_document" "vpc_flow_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "vpc_flowlog" {
  name = "${var.vpc_name}-vpc-flowlog-policy"
  role = aws_iam_role.vpc_flowlog.id
  policy = data.aws_iam_policy_document.vpc_flowlog_policy.json
}

data "aws_iam_policy_document" "vpc_flowlog_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = [aws_cloudwatch_log_group.vpc_flow.arn]
  }
}

resource "aws_flow_log" "this" {
  count                = var.enable_vpc_flow_log ? 1 : 0
  log_destination      = aws_cloudwatch_log_group.vpc_flow.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = var.flow_log_traffic_type
  vpc_id               = module.vpc.vpc_id
  iam_role_arn         = aws_iam_role.vpc_flowlog.arn

  tags = merge({
    Name = "${var.vpc_name}-flowlog"
  }, var.tags)
}

