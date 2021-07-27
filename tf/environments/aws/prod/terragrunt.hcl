remote_state {
  backend  = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config   = {
    bucket              = "github-runners-489130170427-lead.liatr.io"
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

  harbor_host        = "harbor.internal.lead.prod.liatr.io"
  harbor_insecure    = false
  harbor_cert_source = "none"

  enable_jenkins = true
  jenkins_host   = "jenkins.internal.lead.prod.liatr.io"

  enable_nginx  = true
  ingress_class = "internal-nginx"

  enable_sonarqube = true
  sonarqube_host   = "sonarqube.internal.lead.prod.liatr.io"

  enable_keycloak = true
  keycloak_host   = "keycloak.internal.lead.prod.liatr.io"

  elasticsearch_replicas = "3"
  rode_host              = "rode.rode.lead.prod.liatr.io"
  rode_ui_host           = "rode-ui.internal.lead.prod.liatr.io"
  tfsec_collector_host   = "tfsec-collector.rode.lead.prod.liatr.io"
  update_coredns         = false

  rode_ui_version             = "v0.17.3"
  rode_version                = "v0.14.5"
  grafeas_version             = "v0.8.2"
  build_collector_version     = "v0.3.3"
  harbor_collector_version    = "v0.2.2"
  tfsec_collector_version     = "v0.1.1"
  sonarqube_collector_version = "v0.2.1"

  namespace_annotations = {
    "downscaler/exclude" = "true"
  }
}
