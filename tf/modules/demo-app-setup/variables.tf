variable "environments" {
  type    = set(string)
  default = []
}

variable "deploy_namespace" {
  type = string
}

variable "harbor_host" {
  type = string
}

variable "harbor_namespace" {
  type = string
}

variable "harbor_secret" {
  type    = string
  default = "harbor-harbor-core"
}
