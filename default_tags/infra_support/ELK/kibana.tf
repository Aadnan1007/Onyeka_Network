resource "helm_release" "kibana" {
  repository = "https://helm.elastic.co"
  chart      = "kibana"
  name       = "kibana"
  namespace  = var.namespace
  version    = var.elk_version
  timeout    = "120"

  values = [
    "${file("kibana-values.yaml")}"
  ]

  set {
    name  = "imageTag"
    value = var.elk_version
  }
}