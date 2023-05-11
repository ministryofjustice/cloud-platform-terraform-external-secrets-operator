
locals {
  external_secrets_service_account_name = "external-secrets-operator"
  secrets_prefix = "cloud-platform-environments"
}

module "external_secrets_iam_assumable_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       =  "~> 5.0"
  create_role                   = true
  role_name                     = "eso.${var.cluster_domain_name}"
  role_description              = "Role for External Secrets Operator. Corresponds to external-secrets k8s ServiceAccount."
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [length(aws_iam_policy.external_secrets) >= 1 ? aws_iam_policy.external_secrets.arn : ""]
  oidc_fully_qualified_subjects = ["system:serviceaccount:external-secrets-operator:${local.external_secrets_service_account_name}"]
}

resource "aws_iam_policy" "external_secrets" {
  name_prefix = "eks_external_secrets"
  description = "EKS external-secrets operator policy for cluster ${var.cluster_domain_name}"
  policy      = data.aws_iam_policy_document.external_secrets.json
}

# Policy as documented here:
# https://external-secrets.io/provider-aws-secrets-manager/#iam-policy
data "aws_iam_policy_document" "external_secrets" {
  statement {
    sid    = "externalSecretsSecretsManager"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.secrets_prefix}/*",
    ]
  }
}   