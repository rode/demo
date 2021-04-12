remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}.tfstate"
  }
}

terraform {
  source = "../../k8s/environments/local/"
}