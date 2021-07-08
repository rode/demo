resource "kubernetes_namespace" "keycloak" {
  metadata {
    name        = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "random_password" "keycloak_admin_password" {
  length  = 12
  special = false
}

resource "random_password" "postgres_password" {
  length  = 12
  special = false
}

resource "kubernetes_secret" "keycloak_credentials" {
  metadata {
    name      = "keycloak-credentials"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  type = "Opaque"

  data = {
    admin_username = "keycloak"
    admin_password = random_password.keycloak_admin_password.result
  }
}

resource "helm_release" "keycloak" {
  repository = "https://codecentric.github.io/helm-charts"
  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name
  chart      = "keycloak"
  version    = "11.0.1"
  timeout    = 1200
  wait       = true

  values = [
    templatefile("${path.module}/values.tpl", {
      ingress_class    = var.ingress_class
      ingress_hostname = var.keycloak_host
      keycloak_secret  = kubernetes_secret.keycloak_credentials.metadata[0].name
    })
  ]

  set_sensitive {
    name  = "postgresql.postgresqlPassword"
    value = random_password.postgres_password.result
  }
}

resource "keycloak_realm" "rode_demo" {
  realm   = "rode-demo"
  enabled = true

  depends_on = [
    helm_release.keycloak,
  ]
}

resource "keycloak_openid_client" "rode" {
  realm_id                     = keycloak_realm.rode_demo.id
  client_id                    = "rode"
  name                         = "Rode"
  access_type                  = "CONFIDENTIAL"
  // Rode UI uses the authorization code flow
  standard_flow_enabled        = true
  // password grant allows for easier local development and testing
  direct_access_grants_enabled = true
  // client credentials for the collectors and enforcers
  service_accounts_enabled     = true
  enabled                      = true
  valid_redirect_uris          = [
    "http://localhost:3000/",
    "http://localhost:3000/callback",
    "https://${var.rode_ui_host}/",
    "https://${var.rode_ui_host}/callback"
  ]
}

resource "keycloak_openid_audience_protocol_mapper" "rode_audience" {
  realm_id  = keycloak_realm.rode_demo.id
  client_id = keycloak_openid_client.rode.id
  name      = "rode-audience-mapper"

  included_client_audience = keycloak_openid_client.rode.client_id
}
