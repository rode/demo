locals {
  elasticsearch_username = "rode"
}

resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name        = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "random_password" "elasticsearch_password" {
  length  = 12
  special = false
}

resource "kubernetes_secret" "elasticsearch_creds" {
  metadata {
    name      = "elasticsearch-credentials"
    namespace = kubernetes_namespace.elasticsearch.metadata[0].name
  }

  type = "Opaque"
  data = {
    username = "rode"
    password = random_password.elasticsearch_password.result
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  namespace  = kubernetes_namespace.elasticsearch.metadata[0].name
  chart      = "elasticsearch"
  repository = "https://helm.elastic.co"
  version    = "7.10.1"
  wait       = true
  timeout    = 600

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      elasticsearch_credentials_secret_name = kubernetes_secret.elasticsearch_creds.metadata[0].name
      replicas                              = var.replicas
    })
  ]
}
