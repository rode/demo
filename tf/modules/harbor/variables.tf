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
