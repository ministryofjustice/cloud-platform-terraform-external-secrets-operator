variable "cluster_domain_name" {
  description = "The cluster domain used for externalDNS annotations and certmanager"
}


variable "eks_cluster_oidc_issuer_url" {
  description = "If EKS variable is set to true this is going to be used when we create the IAM OIDC role"
  type        = string
  default     = ""
}

variable "secrets_prefix" {
  description = "Prefix for secrets in AWS Secrets Manager"
  type        = string
}
