data "kubernetes_config_map" "original_coredns" {
  metadata {
    name      = "coredns"
    namespace = "kube-system"
  }
}

resource "kubernetes_config_map" "original_coredns" {
  metadata {
    name      = "coredns-backup"
    namespace = "kube-system"
  }
  data = data.kubernetes_config_map.original_coredns.data
  lifecycle {
    ignore_changes = [data]
  }
}

locals {
  rewrite_line      = "rewrite name ${var.harbor_host} ${var.nginx_service_url}"
  corefile_modified = <<EOF
${replace(kubernetes_config_map.original_coredns.data.Corefile, ".:53 {\n", ".:53 {\n    ${local.rewrite_line}\n")}
  EOF
  modified_yaml     = yamlencode({ "data" : { "Corefile" : local.corefile_modified } })
  original_yaml     = yamlencode({ "data" : kubernetes_config_map.original_coredns.data })
}

module "kubectl_patch_coredns" {
  source               = "matti/resource/shell"
  command              = "kubectl patch configmap coredns -n kube-system -p \"${local.modified_yaml}\""
  command_when_destroy = "kubectl patch configmap coredns -n kube-system -p \"${local.original_yaml}\""
}
