remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "github-runners-489130170427-lead.liatr.io"
    region         = "us-east-1"
    key            = "${get_env("GITHUB_REPOSITORY", "UNDEFINED")}-terraform.tfstate"
    encrypt        = true
    dynamodb_table = "github-runners-lead"
    s3_bucket_tags = {
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

  harbor_host     = "harbor.rode.lead.prod.liatr.io"
  harbor_insecure = true

  jenkins_host = "jenkins.rode.lead.prod.liatr.io"

  enable_nginx           = true
  enable_jenkins         = true
  elasticsearch_replicas = "3"
  rode_ui_host           = "rode-ui.rode.lead.prod.liatr.io"
  update_coredns         = "false"
  rode_ui_version        = "v0.8.0"
  rode_version           = "v0.6.0"
  grafeas_version        = "v0.6.4"
}
