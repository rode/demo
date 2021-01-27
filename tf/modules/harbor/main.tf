resource "kubernetes_namespace" "harbor" {
  metadata {
    name = "harbor"
  }
}

resource "random_password" "harbor_admin_password" {
  length  = 12
  special = false
}

resource "helm_release" "harbor" {
  name       = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  chart      = "harbor"
  repository = "https://helm.goharbor.io"
  version    = "1.5.3"
  wait       = true

  set_sensitive {
    name  = "harborAdminPassword"
    value = random_password.harbor_admin_password.result
  }

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      harbor_host        = var.host
      harbor_cert_source = var.cert_source
    })
  ]
}
