variable "namespace" {
  default = "sonarqube"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "host" {}
variable "ingress_class" {}
variable "rode_host" {}
variable "sonarqube_collector_version" {
  default = ""
}
