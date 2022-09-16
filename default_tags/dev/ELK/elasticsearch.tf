#As these are included in terragrunt.hcl file we can remove the providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
  }
}

resource "kubernetes_namespace" "elk" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "elasticsearch" {
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"
  name       = "elasticsearch"
  namespace  = var.namespace
  version    = var.elk_version
  timeout    = "120"

  values = [
    "${file("elasticsearch-values.yaml")}"
  ]

  set {
    name  = "imageTag"
    value = var.elk_version
  }
}
