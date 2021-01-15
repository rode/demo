include {
  path = "${find_in_parent_folders()}"
}

inputs = {
  kube_context = "docker-desktop"
  harbor_host  = "harbor.localhost"
  enable_nginx = true
}
