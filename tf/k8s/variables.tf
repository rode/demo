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
variable "deploy_namespace" {
  default = "rode-demo-app"
}
variable "enable_jenkins" {
  default = true
}
variable "rode_ui_host" {}
variable "rode_ui_version" {
  default = ""
}
variable "rode_version" {
  default = ""
}
variable "grafeas_version" {
  default = ""
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
variable "ingress_class" {
  default = ""
}
variable "enable_sonarqube" {
  default = true
}
variable "sonarqube_host" {}
variable "sonarqube_namespace" {
  default = "rode-demo-sonarqube"
}
