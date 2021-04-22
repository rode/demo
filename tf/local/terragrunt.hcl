remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "${path_relative_to_include()}.tfstate"
  }
}

inputs = {
  kube_context = "docker-desktop"
  kube_config  = "~/.kube/config"

  harbor_host     = "harbor.localhost"
  harbor_insecure = true

  jenkins_host = "jenkins.localhost"

  enable_nginx   = true
  enable_jenkins = true
  rode_ui_host   = "rode-ui.localhost"

  rode_ui_version = "v0.4.0"
  rode_version    = "v0.5.1"
  grafeas_version = "v0.6.2"
}

terraform {
  source = "..//k8s"
}
