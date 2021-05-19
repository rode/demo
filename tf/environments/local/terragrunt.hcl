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

  rode_ui_host            = "rode-ui.localhost"
  rode_ui_version         = "v0.9.0"
  rode_version            = "v0.8.0"
  grafeas_version         = "v0.7.0"
  build_collector_version = "v0.3.0"
  ingress_name            = "nginx"
}
