provider "aws" {
  region  = "eu-west-2"
}

module "eso" {
  source = "../"
    cluster_domain_name             = "eso.cloud-platform.service.justice.gov.uk"
    secrets_prefix = "test"
}
