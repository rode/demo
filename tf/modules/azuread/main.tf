locals {
  roles = toset([
    "Collector",
    "Enforcer",
    "ApplicationDeveloper",
    "PolicyDeveloper",
    "PolicyAdministrator",
    "Administrator"
  ])
}

data "azuread_client_config" "current" {}

data "azuread_service_principal" "ms_graph" {
  display_name = "Microsoft Graph"
}

resource "random_password" "client_secret" {
  length = 12
}

resource "random_uuid" "scope_id" {}

resource "azuread_application" "rode" {
  display_name     = "rode"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = ["api://rode"]

  web {
    homepage_url  = "https://${var.rode_ui_host}"
    redirect_uris = [
      "http://localhost:3000/",
      "http://localhost:3000/callback",
      "https://${var.rode_ui_host}/",
      "https://${var.rode_ui_host}/callback",
    ]

    implicit_grant {
      access_token_issuance_enabled = false
    }
  }

  api {
    oauth2_permission_scope {
      id                         = random_uuid.scope_id.result
      enabled                    = true
      type                       = "User"
      value                      = "rode"
      admin_consent_description  = "Access Rode application"
      admin_consent_display_name = "Access Rode application"
      user_consent_description   = "Access Rode application"
      user_consent_display_name  = "Access Rode application"
    }
  }

  dynamic "app_role" {
    for_each = local.roles
    content {
      allowed_member_types = [
        "User"]
      enabled              = true
      description          = app_role.value
      display_name         = app_role.value
    }
  }

  prevent_duplicate_names        = true
  fallback_public_client_enabled = false

  owners = [
    data.azuread_client_config.current.object_id,
  ]

  provisioner "local-exec" {
    command = <<EOT
az rest -m patch -u "https://graph.microsoft.com/beta/applications/${azuread_application.rode.id}" \
  -b '{"api": {"requestedAccessTokenVersion": 2}, "web": {"implicitGrantSettings": {"enableIdTokenIssuance":false}}}' \
  --headers "Content-Type=application/json"
EOT
  }
}

resource "azuread_service_principal" "rode" {
  app_role_assignment_required = true
  application_id               = azuread_application.rode.application_id
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.rode.object_id
  value                 = random_password.client_secret.result
  end_date_relative     = format("%dh", 5 * 365 * 24)
}
