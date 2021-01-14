resource "kubernetes_namespace" "grafeas" {
  metadata {
    name = "grafeas"
  }
}

resource "helm_release" "grafeas" {
  name       = "grafeas-elasticsearch"
  namespace  = kubernetes_namespace.grafeas.metadata[0].name
  chart      = "grafeas-elasticsearch"
  repository = "https://rode.github.io/charts"
  version    = "0.0.1"
  wait       = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      elasticsearch_url = "http://${var.elasticsearch_host}"
      elasticsearch_username = var.elasticsearch_username
      elasticsearch_password = var.elasticsearch_host
    })
  ]
}
