variable "namespace" {
  default = "nginx"
}
variable "namespace_annotations" {
  type    = map(string)
  default = {}
}
