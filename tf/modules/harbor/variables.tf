variable "namespace" {
  default = "harbor"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "host" {}
variable "cert_source" {}
variable "ingress_class" {}
variable "harbor_collector_version" {
  default = ""
}
variable "harbor_insecure" {}
variable "rode_host" {}
