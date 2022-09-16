variable "root_domain" {
  type    = string
  default = ""
}

variable "cluster-name" {
  type    = string
  default = ""
}

variable "namespace" {
  type    = string
  default = "elk"
}

variable "elk_version" {
  type    = string
  default = "7.17.3"
}