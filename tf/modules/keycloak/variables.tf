variable "namespace" {
  type    = string
  default = "rode-demo-keycloak"
}

variable "namespace_annotations" {
  type = map(string)
}

variable "ingress_class" {
  type = string
}

variable "keycloak_host" {
  type = string
}
