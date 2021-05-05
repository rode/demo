variable "namespace" {
  default = "elasticsearch"
}

variable "namespace_annotations" {
  type    = map(string)
  default = {}
}

variable "replicas" {
  default = "1"
}