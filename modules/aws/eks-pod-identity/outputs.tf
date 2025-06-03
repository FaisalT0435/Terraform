output "pod_identity_role_arn" {
  value = aws_iam_role.pod_identity.arn
}
output "pod_identity_association_id" {
  value = aws_eks_pod_identity_association.this.id
}
