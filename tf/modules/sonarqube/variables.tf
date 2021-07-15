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
