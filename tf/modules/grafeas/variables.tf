variable "namespace" {
  default = "grafeas"
}
variable "elasticsearch_username" {}
variable "elasticsearch_password" {}
variable "elasticsearch_host" {}
variable "grafeas_host" {
  default = ""
}
variable "grafeas_version" {
  default = "v0.6.1"
}
