serviceAccount:
  create: true
  name: "${service_account_name}"
  annotations: 
    eks.amazonaws.com/role-arn: "${irsa_role_arn}"

serviceMonitor:
  # -- Specifies whether to create a ServiceMonitor resource for collecting Prometheus metrics
  enabled: true
