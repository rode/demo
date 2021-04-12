remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}.tfstate"
  }
}

terraform {
  source = "../..//k8s/environments/local/"
}

inputs = {
  kube_context = "docker-desktop"

  harbor_host     = "harbor.localhost"
  harbor_insecure = true

  jenkins_host = "jenkins.localhost"

  enable_nginx    = true
  enable_jenkins  = true
  rode_ui_host    = "rode-ui.localhost"
  rode_ui_version = "v0.2.0"
}