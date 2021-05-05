locals {
  env_hash = "${get_env("RODE_ENV_HASH", "UNDEFINED")}"
}
remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config   = {
    bucket              = "github-runners-489130170427-lead.liatr.io"
    region              = "us-east-1"
    key                 = "${get_env("GITHUB_REPOSITORY", "UNDEFINED")}-${local.env_hash}-terraform.tfstate"
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

  harbor_host        = "harbor-${local.env_hash}.internal.lead.prod.liatr.io"
  harbor_insecure    = false
  harbor_cert_source = "none"

  enable_jenkins = true
  jenkins_host   = "jenkins-${local.env_hash}.internal.lead.prod.liatr.io"

  enable_nginx  = false
  ingress_class = "internal-nginx"

  elasticsearch_replicas = "3"
  rode_ui_host           = "rode-ui-${local.env_hash}.internal.lead.prod.liatr.io"
  update_coredns         = false
  rode_ui_version        = "v0.8.0"
  rode_version           = "v0.6.1"
  grafeas_version        = "v0.6.4"
  rode_namespace = "rode-demo-${local.env_hash}"
  deploy_namespace = "rode-demo-app-${local.env_hash}"
  jenkins_namespace = "rode-demo-jenkins-${local.env_hash}"
  elasticsearch_namespace = "rode-demo-elasticsearch-${local.env_hash}"
  grafeas_namespace = "rode-demo-grafeas-${local.env_hash}"
  harbor_namespace = "rode-demo-harbor-${local.env_hash}"

}
