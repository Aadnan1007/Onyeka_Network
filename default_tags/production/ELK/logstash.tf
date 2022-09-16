resource "helm_release" "logstash" {
  repository = "https://helm.elastic.co"
  chart      = "logstash"
  name       = "logstash"
  namespace  = var.namespace
  version    = var.elk_version
  timeout    = "120"

  values = [
    "${file("logstash-values.yaml")}"
  ]

  set {
    name  = "imageTag"
    value = var.elk_version
  }
}