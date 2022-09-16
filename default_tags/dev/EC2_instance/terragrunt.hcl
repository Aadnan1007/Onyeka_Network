include {
  path = "../../terragrunt.hcl"
}

dependency "eks" {
  config_path = "../common_cluster/eks"

  mock_outputs = {
    cluster_id              = "cluster-name"
    cluster_oidc_issuer_url = "https://oidc.eks.us-east-1.amazonaws.com/id/0000000000000000"
  }
}

dependency "cert-manager-config" {
  config_path = "../common_cluster/cert-manager-config"

  mock_outputs = {
    prod_tls_cert_secret_name = "prod-tls-cert"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
   provider "aws" {
     region = "${local.aws_region}"
     version = "~> 4.0.0"
    }
  provider "kubernetes" {
   host = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token = data.aws_eks_cluster_auth.cluster.token
  }
 provider "helm" {
  kubernetes {
   host = data.aws_eks_cluster.cluster.endpoint
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
   token = data.aws_eks_cluster_auth.cluster.token
  }
}
data "aws_eks_cluster" "cluster" {
 name = var.cluster-name
 }
data "aws_eks_cluster_auth" "cluster" {
 name = var.cluster-name
 }
 terraform {
  required_providers {
    onepassword = {
      source  = "anasinnyk/onepassword"
      version = "1.2.1"
    }
    aws = {
      source  = "aws"
      version = "4.0.0"
    }
    helm = {
      source  = "helm"
      version = "2.5.1"
    }
    kubernetes = {
      source  = "kubernetes"
      version = "2.11.0"
    }
  }
}

provider "onepassword" {
  subdomain = "ntwrk-team"
}
EOF
}

locals {
  aws_region  = yamldecode(file("${find_in_parent_folders("cluster_config.yaml")}"))["aws_region"]
  environment = yamldecode(file("${find_in_parent_folders("cluster_config.yaml")}"))["environment"]
  # custom_tags = merge(
  #   yamldecode(file("${find_in_parent_folders("environment_tags.yaml")}")),
  #   yamidecode(file("s(find_in_parent_folders ("global_tags.yaml")}"))
  # )
  cluster-name = yamldecode(file("${find_in_parent_folders("cluster_config.yaml")}"))["cluster-name"]
  root_domain  = yamldecode(file("${find_in_parent_folders("cluster_config.yaml")}"))["root_domain"]
}

inputs = {
  cluster-name            = dependency.eks.outputs.cluster_id
  cluster_oidc_issuer_url = dependency.eks.outputs.cluster_oidc_issuer_url
  # tags                    = local.custom_tags
  root_domain = local.root_domain
}