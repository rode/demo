remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config   = {
    bucket              = "github-runners-sandbox-lead.liatr.io"
    region              = "us-east-1"
    key                 = "${get_env("GITHUB_REPOSITORY", "UNDEFINED")}-terraform.tfstate"
    encrypt             = true
    dynamodb_table      = "github-runners-lead"
    s3_bucket_tags      = {
      owner = "Terragrunt"
      name  = "Terraform State Manager"
    }
    dynamodb_table_tags = {
      owner = "Terragrunt"
      name  = "Terraform Lock Table"
    }
  }
}

terraform {
  source = "../../..//k8s/"
}

inputs = {
  kube_context = ""
  kube_config  = ""

  harbor_host        = "harbor.internal.lead.sandbox.liatr.io"
  harbor_insecure    = false
  harbor_cert_source = "none"

  enable_jenkins = true
  jenkins_host   = "jenkins.internal.lead.sandbox.liatr.io"

  enable_nginx  = false
  ingress_class = "internal-nginx"

  elasticsearch_replicas  = "3"
  rode_ui_host            = "rode-ui.internal.lead.sandbox.liatr.io"
  update_coredns          = false
  rode_ui_version         = "v0.8.0"
  rode_version            = "v0.6.1"
  grafeas_version         = "v0.6.4"
  build_collector_version = "v0.3.0"
}
