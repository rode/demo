variable "namespace" {
  default = "grafeas"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "elasticsearch_username" {}
variable "elasticsearch_password" {}
variable "elasticsearch_host" {}
variable "grafeas_host" {
  default = ""
}
variable "grafeas_version" {
  default = ""
}
