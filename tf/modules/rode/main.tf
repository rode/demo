resource "kubernetes_namespace" "rode" {
  metadata {
    name = "rode"
  }
}

resource "helm_release" "rode" {
  name       = "rode"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode"
  repository = "https://rode.github.io/charts"
  version    = "0.0.3"
  wait       = true

  values = [
    templatefile("${path.module}/rode-values.yaml.tpl", {})
  ]
}

resource "kubernetes_ingress" "rode" {
  count = var.host == "" ? 0 : 1

  metadata {
    namespace   = kubernetes_namespace.rode.metadata[0].name
    name        = "rode"
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "GRPC"
    }
  }
  spec {
    backend {
      service_name = "rode"
      service_port = 50051
    }

    rule {
      host = var.host

      http {
        path {
          path = "/"
          backend {
            service_name = "rode"
            service_port = 50051
          }
        }
      }
    }

    tls {
      hosts = [
        var.host
      ]
    }
  }
}

resource "helm_release" "rode_collector_harbor" {
  name       = "rode-collector-harbor"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode-collector-harbor"
  repository = "https://rode.github.io/charts"
  version    = "0.0.2"
  wait       = true

  values = [
    templatefile("${path.module}/rode-collector-harbor-values.yaml.tpl", {
      harbor_host     = var.harbor_host
      harbor_username = var.harbor_username
      harbor_password = var.harbor_password
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}
