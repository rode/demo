variable "host" {
  default = ""
}
variable "namespace" {
  default = "rode"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
variable "grafeas_namespace" {
  default = "grafeas"
}
variable "elasticsearch_host" {}
variable "rode_ui_host" {}
variable "rode_ui_version" {
  default = ""
}
variable "rode_version" {
  default = ""
}
variable "build_collector_version" {
  default = ""
}

variable "tfsec_collector_version" {
  default = ""
}

variable "tfsec_collector_host" {
  default = ""
}

variable "ingress_class" {
  default = ""
}

variable "oidc_auth_enabled" {
  type    = bool
  default = false
}

variable "oidc_issuer" {
  type    = string
  default = ""
}

variable "oidc_token_url" {
  type    = string
  default = ""
}

variable "oidc_rode_client_id" {
  type    = string
  default = ""
}

variable "oidc_rode_client_secret" {
  type    = string
  default = ""
}

variable "oidc_admin_username" {
  type    = string
  default = ""
}

variable "oidc_admin_password" {
  type    = string
  default = ""
}

variable "oidc_tls_insecure_skip_verify" {
  type    = bool
  default = false
}
