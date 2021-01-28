terraform {
  backend "local" {}

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.13.3"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.0.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
}

provider "kubernetes" {
  config_context = var.kube_context
  config_path    = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_context = var.kube_context
    config_path    = "~/.kube/config"
  }
}

module "elasticsearch" {
  source    = "../modules/elasticsearch"
  namespace = "rode-demo-elasticsearch"
}

module "grafeas" {
  source = "../modules/grafeas"

  namespace              = "rode-demo-grafeas"
  elasticsearch_host     = module.elasticsearch.host
  elasticsearch_username = module.elasticsearch.username
  elasticsearch_password = module.elasticsearch.password

  grafeas_host = var.grafeas_host

  depends_on = [
    module.elasticsearch
  ]
}

module "rode" {
  source = "../modules/rode"

  host = var.rode_host

  harbor_url     = var.rode_collector_use_internal_network ? "" : "https://${var.harbor_host}"
  harbor_password = module.harbor.harbor_password
  harbor_username = module.harbor.harbor_username
  namespace = "rode-demo"
  grafeas_namespace = "rode-demo-grafeas"

  depends_on = [
    module.grafeas
  ]
}

module "nginx" {
  count     = var.enable_nginx ? 1 : 0
  source    = "../modules/nginx"
  namespace = "rode-demo-nginx"
}

module "harbor" {
  source = "../modules/harbor"

  namespace   = "rode-demo-harbor"
  host        = var.harbor_host
  cert_source = var.harbor_cert_source
}
