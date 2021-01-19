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
    templatefile("${path.module}/values.yaml.tpl", {})
  ]
}
