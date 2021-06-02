terraform {
  required_version = ">= 0.13.1"
  required_providers {
    sonarqube = {
      source  = "github.com/jdamata/sonarqube"
      version = "0.1"
    }
  }
}
