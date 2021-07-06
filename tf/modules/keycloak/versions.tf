terraform {
  required_version = ">= 0.13.1"
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.2.0-rc.0"
    }
  }
}
