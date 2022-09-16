resource "helm_release" "metricbeat" {
  repository = "https://helm.elastic.co"
  chart      = "metricbeat"
  name       = "metricbeat"
  namespace  = var.namespace
  version    = var.elk_version
  timeout    = "120"

  values = [
    "${file("metricbeat-values.yaml")}"
  ]

  set {
    name  = "imageTag"
    value = var.elk_version
  }
}