locals {
  roles = toset([
    "Collector",
    "Enforcer",
    "Application Developer",
    "Policy Developer",
    "Policy Administrator",
    "Administrator"
  ])

  users = tomap({
  for role in local.roles : role => replace(lower(role), " ", "-")
  })
}

resource "keycloak_role" "demo_role" {
  for_each  = local.roles
  realm_id  = keycloak_realm.rode_demo.id
  client_id = keycloak_openid_client.rode.id
  name      = each.key
}

resource "keycloak_group" "demo_group" {
  for_each = local.roles
  realm_id = keycloak_realm.rode_demo.id
  name     = "${each.key}s"
}

resource "keycloak_group_roles" "demo_group_role" {
  for_each = local.roles
  realm_id = keycloak_realm.rode_demo.id
  group_id = keycloak_group.demo_group[each.key].id

  role_ids = [
    keycloak_role.demo_role[each.key].id,
  ]
}

resource "random_password" "demo_user_password" {
  for_each = local.users
  length   = 12
  special  = false
}

resource "keycloak_user" "demo_user" {
  for_each = local.users
  realm_id = keycloak_realm.rode_demo.id
  username = each.value
  enabled  = true

  first_name = each.value

  initial_password {
    value = random_password.demo_user_password[each.key].result
  }
}

resource "keycloak_user_groups" "demo_user_groups" {
  for_each = local.users
  realm_id = keycloak_realm.rode_demo.id
  user_id  = keycloak_user.demo_user[each.key].id

  group_ids = [
    keycloak_group.demo_group[each.key].id
  ]
}

resource "kubernetes_secret" "user_credentials" {
  metadata {
    name      = "user-credentials"
    namespace = kubernetes_namespace.keycloak.metadata[0].name
  }
  type = "Opaque"

  data = {
  for role, user in local.users : user => random_password.demo_user_password[role].result
  }
}