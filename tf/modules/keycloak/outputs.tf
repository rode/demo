output "keycloak_admin_password" {
  value     = random_password.keycloak_admin_password.result
  sensitive = true
  depends_on = [
    helm_release.keycloak
  ]
}

output "rode_client_id" {
  value = keycloak_openid_client.rode.client_id
}

output "rode_client_secret" {
  value = keycloak_openid_client.rode.client_secret

  sensitive = true
}

output "service_account_client_id" {
  value = tomap({
    for s in local.rode_service_accounts : s => keycloak_openid_client.service_account[s].client_id
  })
}

output "service_account_client_secret" {
  value = tomap({
    for s in local.rode_service_accounts : s => keycloak_openid_client.service_account[s].client_secret
  })

  sensitive = true
}

output "token_url" {
  value = "https://${var.keycloak_host}/auth/realms/${keycloak_realm.rode_demo.realm}/protocol/openid-connect/token"
}

output "issuer_url" {
  value = "https://${var.keycloak_host}/auth/realms/${keycloak_realm.rode_demo.realm}"
}

output "admin_username" {
  value = keycloak_user.demo_user["Administrator"].username
}

output "admin_password" {
  value = random_password.demo_user_password["Administrator"].result
}
