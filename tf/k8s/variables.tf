variable "kube_context" {}
variable "harbor_host" {}
variable "jenkins_host" {}
variable "enable_nginx" {
  default = true
}
variable "update_coredns" {
  default = true
}
