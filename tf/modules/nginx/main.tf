locals {
  signed_certificate_secret_name = "wildcard-certificate"
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "nginx" {
  chart      = "ingress-nginx"
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "3.20.1"
  namespace  = kubernetes_namespace.nginx.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]
}
