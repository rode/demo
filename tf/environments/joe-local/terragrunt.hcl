remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "${path_relative_to_include()}.tfstate"
  }
}

terraform {
  source = "../..//k8s/"
}

inputs = {
  kube_context = "arn:aws:eks:us-east-1:774051255656:cluster/lead"
  kube_config  = "~/.kube/config"

  harbor_host     = "harbor.rode-joe.lead.sandbox.liatr.io"
  harbor_insecure = true

  jenkins_host = "jenkins.rode-joe.lead.sandbox.liatr.io"

  enable_nginx    = false
  enable_jenkins  = true
  elasticsearch_replicas = "3"
  rode_ui_host    = "rode-ui.rode-joe.lead.sandbox.liatr.io"
  rode_ui_version = "v0.2.0"
  update_coredns  = "false"
  rode_namespace= "joe-rode-demo"
  jenkins_namespace = "joe-rode-demo-jenkins"
  elasticsearch_namespace = "joe-rode-demo-elasticsearch"
  grafeas_namespace = "joe-rode-demo-grafeas"
  harbor_namespace = "joe-rode-demo-harbor"
  nginx_namespace = "joe-rode-demo-nginx"
}
