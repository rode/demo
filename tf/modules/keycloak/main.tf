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

resource "random_password" "policy_admin_password" {
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
    admin_username             = "keycloak"
    admin_password             = random_password.keycloak_admin_password.result
    rode_policy_admin_password = random_password.policy_admin_password.result
  }
}

// TODO: upgrade keycloak
resource "helm_release" "keycloak" {
  repository = "https://codecentric.github.io/helm-charts"
  name       = "keycloak"
  namespace  = kubernetes_namespace.keycloak.metadata[0].name
  chart      = "keycloak"
  version    = "9.0.5"
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
  realm_id    = keycloak_realm.rode_demo.id
  client_id   = "rode"
  name        = "Rode"
  access_type = "BEARER-ONLY"
  enabled     = true
}

resource "keycloak_role" "policy_admin_role" {
  realm_id    = keycloak_realm.rode_demo.id
  client_id   = keycloak_openid_client.rode.id
  name        = "Policy Administrator"
  description = "Rode Policy Administrator"
}

resource "keycloak_openid_client" "rode_ui" {
  realm_id  = keycloak_realm.rode_demo.id
  client_id = "rode-ui"

  name    = "Rode UI"
  enabled = true

  standard_flow_enabled        = true
  direct_access_grants_enabled = true
  access_type                  = "CONFIDENTIAL"
  valid_redirect_uris = [
    "https://rode-ui.local/callback"
  ]
}

resource "keycloak_openid_audience_protocol_mapper" "rode_ui_audience" {
  realm_id  = keycloak_realm.rode_demo.id
  client_id = keycloak_openid_client.rode_ui.id
  name      = "rode-ui-audience-mapper"

  included_custom_audience = "rode-ui"
}

// ensure that tokens rode-ui receives can be used with Rode
resource "keycloak_openid_audience_protocol_mapper" "rode_audience" {
  realm_id  = keycloak_realm.rode_demo.id
  client_id = keycloak_openid_client.rode_ui.id
  name      = "rode-audience-mapper"

  included_custom_audience = "rode"
}

resource "keycloak_user" "policy_admin" {
  realm_id = keycloak_realm.rode_demo.id
  username = "rode-policy-admin"
  enabled  = true

  email      = "policy-admin@rode.liatrio.com"
  first_name = "Policy"
  last_name  = "Administrator"

  initial_password {
    value = random_password.policy_admin_password.result
  }
}

resource "keycloak_group" "rode_policy_admins" {
  realm_id = keycloak_realm.rode_demo.id
  name     = "rode-policy-admins"
}

resource "keycloak_user_groups" "policy_admin" {
  realm_id = keycloak_realm.rode_demo.id
  user_id  = keycloak_user.policy_admin.id

  group_ids = [
    keycloak_group.rode_policy_admins.id
  ]
}

resource "keycloak_group_roles" "policy_admin_group_role" {
  realm_id = keycloak_realm.rode_demo.id
  group_id = keycloak_group.rode_policy_admins.id

  role_ids = [
    keycloak_role.policy_admin_role.id,
  ]
}