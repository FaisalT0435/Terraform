resource "aws_iam_role" "pod_identity" {
  name = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [
        "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
      ]
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)
  role       = aws_iam_role.pod_identity.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  count = var.inline_policy_json != null ? 1 : 0
  name  = "${var.role_name}-inline"
  role  = aws_iam_role.pod_identity.id
  policy = var.inline_policy_json
}

resource "aws_eks_pod_identity_association" "this" {
  cluster_name         = var.eks_cluster_name
  namespace            = var.pod_namespace
  service_account      = var.service_account
  role_arn             = aws_iam_role.pod_identity.arn
}


##############################

# memanggil module ke root main.tf 

# module "eks_pod_identity" {
#   source            = "./modules/eks_pod_identity"
#   eks_cluster_name  = "my-eks-cluster"
#   pod_namespace     = "default"
#   service_account   = "myapp-sa"
#   role_name         = "myapp-pod-identity-role"
#   managed_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
#     "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
#   ]
#   # optional: inline_policy_json = file("./policy.json")
# }
