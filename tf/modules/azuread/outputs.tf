output "rode_ui_client_id" {
  value = azuread_application.rode_ui.application_id
}

output "rode_ui_client_secret" {
  sensitive = true
  value     = azuread_application_password.client_secret.value
}
