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

resource "random_uuid" "rode_scope_id" {}

// Define separate Rode and Rode UI app registrations.
// The Rode application defines the app roles and by requesting the Rode scope, they're mapped into the access token.
// Defining a single app registration for Rode and Rode UI means the roles aren't present in the access token, only the id token.
// It also seems to cause issues with refreshing -- AADSTS90009.
resource "azuread_application" "rode" {
  display_name     = "rode"
  sign_in_audience = "AzureADMyOrg"
  identifier_uris = ["api://rode"]

  api {
    oauth2_permission_scope {
      id                         = random_uuid.rode_scope_id.result
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
      allowed_member_types = ["User", "Application"]
      enabled      = true
      description  = app_role.value
      display_name = app_role.value
      value        = app_role.value
    }
  }

  prevent_duplicate_names        = true
  fallback_public_client_enabled = false

  owners = [
    data.azuread_client_config.current.object_id,
  ]

  provisioner "local-exec" {
    // Set the token version to v2, which will set the aud claim as the client id.
    // The v1 aud claim value is the identifier_uri, which isn't what Rode expects.
    command = <<EOT
az rest -m patch -u "https://graph.microsoft.com/beta/applications/${azuread_application.rode.id}" \
  -b '{"api": {"requestedAccessTokenVersion": 2}}' \
  --headers "Content-Type=application/json"
EOT
  }
}

resource "azuread_service_principal" "rode" {
  app_role_assignment_required = true
  application_id               = azuread_application.rode.application_id
}

resource "azuread_application" "rode_ui" {
  display_name     = "rode-ui"
  sign_in_audience = "AzureADMyOrg"

  web {
    homepage_url = "https://${var.rode_ui_host}"
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

  required_resource_access {
    resource_app_id = azuread_application.rode.application_id
    resource_access {
      id   = random_uuid.rode_scope_id.result
      type = "Scope"
    }
  }

  owners = [
    data.azuread_client_config.current.object_id,
  ]

  prevent_duplicate_names        = true
  fallback_public_client_enabled = false
}

resource "azuread_service_principal" "rode_ui" {
  app_role_assignment_required = true
  application_id               = azuread_application.rode_ui.application_id
}

resource "random_password" "client_secret" {
  length = 12
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.rode_ui.object_id
  value                 = random_password.client_secret.result
  end_date_relative     = format("%dh", 5 * 365 * 24)
}
