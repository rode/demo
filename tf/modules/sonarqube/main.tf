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

resource "helm_release" "rode_collector_sonarqube" {
  name       = "rode-collector-sonarqube"
  namespace  = kubernetes_namespace.sonarqube.metadata[0].name
  chart      = "rode-collector-sonarqube"
  repository = "https://rode.github.io/charts"
  version    = "0.0.1"
  wait       = true

  values = [
    templatefile("${path.module}/rode-collector-sonarqube-values.yaml.tpl", {
      namespace                   = kubernetes_namespace.sonarqube.metadata[0].name
      sonarqube_collector_version = var.sonarqube_collector_version
      rode_host                   = var.rode_host
    })
  ]
}
