variable "harbor_namespace" {}
variable "harbor_host" {}
variable "jenkins_host" {}
variable "sonarqube_host" {
  default = ""
}
variable "sonarqube_token" {
  default = ""
}
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
