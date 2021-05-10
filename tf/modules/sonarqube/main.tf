resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name        = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "random_password" "admin_password" {
  length  = 12
  special = false
}

resource "helm_release" "sonarqube" {
  chart      = "sonarqube"
  name       = "sonarqube"
  namespace  = kubernetes_namespace.sonarqube.metadata[0].name
  repository = "https://oteemo.github.io/charts"
  version    = "9.6.3"
  wait       = true

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      admin_password = random_password.admin_password.result
      host           = var.host
      ingress_class  = var.ingress_class
    })
  ]
}

resource "kubernetes_secret" "sonarqube_admin_password" {
  metadata {
    namespace = kubernetes_namespace.sonarqube.metadata[0].name
    name      = "sonarqube-admin-credentials"
  }

  data = {
    username = "admin"
    password = random_password.admin_password.result
  }
}
