terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "coredns_config" {
  yaml_body = templatefile("${path.module}/coredata.tpl", {
    harbor_host       = var.harbor_host,
    nginx_service_url = var.nginx_service_url
  })
}