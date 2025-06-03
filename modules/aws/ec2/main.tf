data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cw_agent" {
  name = "${var.instance_name}-cw-agent-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

data "aws_iam_policy_document" "cw_agent" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "cw_agent_policy" {
  name = "${var.instance_name}-cw-agent-inline"
  role = aws_iam_role.cw_agent.id
  policy = data.aws_iam_policy_document.cw_agent.json
}

resource "aws_iam_instance_profile" "cw_agent_profile" {
  name = "${var.instance_name}-cw-agent-profile"
  role = aws_iam_role.cw_agent.name
}

resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile   = aws_iam_instance_profile.cw_agent_profile.name

  associate_public_ip_address = true
  tags = merge({
    Name = "${var.instance_name}-${count.index + 1}"
  }, var.tags)
}
data "local_file" "ssh_key" {
  filename = var.public_key_path
}

resource "aws_key_pair" "uploaded" {
  key_name   = "${var.instance_name}-key"
  public_key = data.local_file.ssh_key.content
}

resource "aws_instance" "this" {
  # ...
  key_name = aws_key_pair.uploaded.key_name
  # ...
}

