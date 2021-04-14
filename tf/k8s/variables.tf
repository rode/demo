variable "kube_context" {}
variable "kube_config" {}
variable "harbor_host" {}
variable "harbor_cert_source" {
  default = "auto"
}
variable "harbor_insecure" {
  default = false
}
variable "elasticsearch_replicas" {
  default = "1"
}
variable "enable_nginx" {
  default = true
}
variable "rode_namespace" {
  default = "rode-demo"
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
  default = "v0.3.0"
}
variable "rode_version" {
  default = "v0.3.0"
}

variable "jenkins_namespace" {
  default = "rode-demo-jenkins"
}
variable "elasticsearch_namespace" {
  default = "rode-demo-elasticsearch"
}
variable "grafeas_namespace" {
  default = "rode-demo-grafeas"
}
variable "harbor_namespace" {
  default = "rode-demo-harbor"
}
variable "nginx_namespace" {
  default = "rode-demo-nginx"
}
