variable "namespace" {
  default = "sonarqube"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "host" {}
variable "ingress_class" {}
