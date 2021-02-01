include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  kube_context = "docker-desktop"

  harbor_host  = "harbor.localhost"
  harbor_insecure = true

  jenkins_host = "jenkins.localhost"

  enable_nginx = true
  enable_jenkins = true
}
