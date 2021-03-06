remote_state {
  backend  = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config   = {
    path = "${path_relative_to_include()}.tfstate"
  }
}

terraform {
  source = "../..//k8s/"
}

inputs = {
  kube_context = "docker-desktop"
  kube_config  = "~/.kube/config"

  harbor_host     = "harbor.localhost"
  harbor_insecure = true

  enable_jenkins = true
  jenkins_host   = "jenkins.localhost"

  enable_nginx = true

  enable_sonarqube = true
  sonarqube_host   = "sonarqube.localhost"

  enable_keycloak = true
  keycloak_host   = "keycloak.localhost"

  tfsec_collector_host = "tfsec-collector.localhost"
  rode_ui_host         = "rode-ui.localhost"
  ingress_name         = "nginx"

  rode_ui_version             = "v0.12.0"
  rode_version                = "v0.9.2"
  grafeas_version             = "v0.8.2"
  build_collector_version     = "v0.3.0"
  harbor_collector_version    = "v0.1.0"
  tfsec_collector_version     = "v0.1.0"
  sonarqube_collector_version = "v0.1.0"
}
