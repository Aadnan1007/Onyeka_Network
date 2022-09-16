generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
     provider "aws" {
     region = "${local.aws_region}"
     version = "~> 4.0.0"
     default_tags = {
        tags = {
          Owner       = "devops"
          Lifecycle   = "static"
          Service     = "infrastructure"
          Repo        = "terraform/infra_dev_cluster"
          Terraform   = "true"
        }
     }
  }
EOF
}