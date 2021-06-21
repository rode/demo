output "keycloak_admin_password" {
  value      = random_password.keycloak_admin_password.result
  sensitive  = true
  depends_on = [
    helm_release.keycloak
  ]
}
