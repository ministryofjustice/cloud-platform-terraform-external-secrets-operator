data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  external_secrets_service_account_name = "external-secrets-operator"
}

#############
# Namespace #
#############
resource "kubernetes_namespace" "external_secrets_operator" {
  metadata {
    name = "external-secrets-operator"

    labels = {
      "name"                                           = "external-secrets-operator"
      "component"                                      = "external-secrets-operator"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "certmanager.k8s.io/disable-validation"          = "true"
      "pod-security.kubernetes.io/enforce"             = "restricted"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"                   = "external-secrets-operator"
      "cloud-platform.justice.gov.uk/business-unit"                 = "Platforms"
      "cloud-platform.justice.gov.uk/owner"                         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"                   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform-out-of-hours-alert"                           = "true"
    }
  }
}
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.17.0"
  namespace     = kubernetes_namespace.external_secrets_operator.id

  values = [templatefile("${path.module}/templates/values.yaml.tpl", {
    service_account_name = local.external_secrets_service_account_name
    irsa_role_arn = module.external_secrets_iam_assumable_role.iam_role_arn
  })]

  depends_on = [
    kubernetes_namespace.external_secrets_operator,
    module.external_secrets_iam_assumable_role,
    ]
 
}

