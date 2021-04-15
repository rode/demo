include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  kube_context = "docker-desktop"

  harbor_host     = "harbor.localhost"
  harbor_insecure = true

  jenkins_host = "jenkins.localhost"

  enable_nginx    = true
  enable_jenkins  = true
  rode_ui_host    = "rode-ui.localhost"

  rode_ui_version = "v0.4.0"
  rode_version    = "v0.5.1"
  grafeas_version = "v0.6.2"
}
