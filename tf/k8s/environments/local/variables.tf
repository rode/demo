variable "kube_context" {}
variable "harbor_host" {}
variable "harbor_cert_source" {
  default = "auto"
}
variable "harbor_insecure" {
  default = false
}
variable "enable_nginx" {
  default = true
}
variable "rode_host" {
  default = ""
}
variable "grafeas_host" {
  default = ""
}
variable "update_coredns" {
  default = true
}
variable "jenkins_host" {
  default = ""
}
variable "enable_jenkins" {
  default = true
}
variable "rode_ui_host" {}
variable "rode_ui_version" {
  default = "v0.1.1"
}