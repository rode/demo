resource "kubernetes_namespace" "grafeas" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "grafeas" {
  name       = "grafeas-elasticsearch"
  namespace  = kubernetes_namespace.grafeas.metadata[0].name
  chart      = "grafeas-elasticsearch"
  repository = "https://rode.github.io/charts"
  version    = "0.0.6"
  wait       = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      elasticsearch_url = "http://${var.elasticsearch_host}"
      elasticsearch_username = var.elasticsearch_username
      elasticsearch_password = var.elasticsearch_host
    })
  ]
}

resource "kubernetes_ingress" "grafeas" {
  count = var.grafeas_host == "" ? 0 : 1

  metadata {
    namespace = kubernetes_namespace.grafeas.metadata[0].name
    name      = "grafeas"
  }
  spec {
    backend {
      service_name = "grafeas-server"
      service_port = 8080
    }

    tls {
      hosts = [
        var.grafeas_host
      ]
    }
  }
}
