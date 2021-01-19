variable "kube_context" {}
variable "harbor_host" {}
variable "harbor_protocol" {
  default = "http"
}
variable "harbor_cert_source" {
  default = "auto"
}
variable "enable_nginx" {
  default = true
}
