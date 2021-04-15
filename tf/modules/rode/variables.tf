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
variable "ingress_class" {
  default = ""
}
