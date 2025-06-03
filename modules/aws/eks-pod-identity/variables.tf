variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "pod_namespace" {
  description = "Kubernetes namespace for the pod"
  type        = string
}

variable "service_account" {
  description = "Kubernetes service account name"
  type        = string
}

variable "role_name" {
  description = "Name for the IAM role"
  type        = string
  default     = "eks-pod-identity-role"
}

variable "managed_policy_arns" {
  description = "List of policy ARNs to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Optional inline IAM policy JSON"
  type        = string
  default     = null
}
