variable "harbor_namespace" {}
variable "harbor_host" {}
variable "jenkins_host" {}
variable "rode_namespace" {}
variable "namespace" {}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "ingress_class" {
  default = ""
}
variable "deploy_namespace" {}

variable "environments" {
  type    = set(string)
  default = []
}
