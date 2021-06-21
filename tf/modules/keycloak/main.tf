// TODO: prefix with rode-demo
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
    namespace = var.namespace
  }
  type = "Opaque"

  data = {
    admin_username = "keycloak"
    admin_password = random_password.keycloak_admin_password.result
  }
}


// TODO: upgrade keycloak
// TODO: raise log level
resource "helm_release" "keycloak" {
  repository = "https://codecentric.github.io/helm-charts"
  name       = "keycloak"
  namespace  = var.namespace
  chart      = "keycloak"
  version    = "9.0.5"
  timeout    = 1200

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
  realm             = "rode-demo"
  enabled           = true
}

resource "keycloak_openid_client" "rode_ui" {
  realm_id            = keycloak_realm.rode_demo.id
  client_id           = "rode-ui"

  name                = "Rode UI"
  enabled             = true

  standard_flow_enabled = true
  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://rode-ui.local/callback"
  ]
}

resource "keycloak_openid_audience_protocol_mapper" "rode_audience" {
  realm_id  = keycloak_realm.rode_demo.id
  client_id = keycloak_openid_client.rode_ui.id
  name      = "rode-audience-mapper"

  included_custom_audience = "rode"
}
