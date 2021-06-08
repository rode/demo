terraform {
  required_version = ">= 0.13.1"
  required_providers {
    sonarqube = {
      source  = "jdamata/sonarqube"
      version = "0.0.5"
    }
  }
}
