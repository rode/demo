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
      host           = var.host
      ingress_class  = var.ingress_class
    })
  ]

  set_sensitive {
    name  = "account.adminPassword"
    value = random_password.admin_password.result
  }
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
  chart      = "/Users/parker/Developer/rode-charts/charts/rode-collector-sonarqube"
#  repository = "https://rode.github.io/charts"
  version    = "0.1.0"
  wait       = true

  set_sensitive {
    name  = "rode.auth.oidc.clientSecret"
    value = var.oidc_client_secret
  }

  values = [
    templatefile("${path.module}/rode-collector-sonarqube-values.yaml.tpl", {
      namespace                   = kubernetes_namespace.sonarqube.metadata[0].name
      sonarqube_collector_version = var.sonarqube_collector_version
      rode_host                   = var.rode_host

      oidc_auth_enabled = var.oidc_auth_enabled
      oidc_client_id    = var.oidc_client_id
      oidc_token_url    = var.oidc_token_url
    })
  ]
}
