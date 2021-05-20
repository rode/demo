variable "host" {
  default = ""
}
variable "harbor_url" {}
variable "harbor_username" {}
variable "harbor_password" {}
variable "harbor_insecure" {}
variable "namespace" {
  default = "rode"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "grafeas_namespace" {
  default = "grafeas"
}
variable "elasticsearch_host" {}
variable "rode_ui_host" {}
variable "rode_ui_version" {
  default = ""
}
variable "rode_version" {
  default = ""
}
variable "build_collector_version" {
  default = ""
}

variable "tfsec_collector_version" {
  default = ""
}

variable "tfsec_collector_host" {
  default = ""
}

variable "ingress_class" {
  default = ""
}
