provider "aws" {
  region  = "eu-west-2"
}

module "eso" {
  source = "../"
    dependence_prometheus           = "ignore"
    #dependence_prometheus           = module.monitoring.prometheus_operator_crds_status
}
