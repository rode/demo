variable "namespace" {
  default = "harbor"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "host" {}
variable "cert_source" {}
variable "ingress_class" {}
variable "harbor_collector_version" {
  default = ""
}
variable "harbor_insecure" {}
variable "rode_host" {}

variable "oidc_auth_enabled" {
  type    = bool
  default = false
}

variable "oidc_client_id" {
  type    = string
  default = ""
}
variable "oidc_client_secret" {
  type    = string
  default = ""
}
variable "oidc_token_url" {
  type    = string
  default = ""
}
