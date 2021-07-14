output "rode_client_id" {
  value = azuread_application.rode.application_id
}

output "rode_client_secret" {
  sensitive = true
  value     = azuread_application_password.client_secret.value
}

output "rode_app_object_id" {
  value = azuread_application.rode.object_id
}

output "rode_sp_object_id" {
  value = azuread_service_principal.rode.object_id
}
