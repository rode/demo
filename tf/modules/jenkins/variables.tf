variable "harbor_namespace" {}
variable "harbor_host" {}
variable "jenkins_host" {}
variable "namespace" {}
variable "ingress_class" {
  default = "nginx"
}
variable "deploy_namespace" {}
