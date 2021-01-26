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

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_context = var.kube_context
  config_path    = "~/.kube/config"
}

provider "kubectl" {
  config_context = var.kube_context
  config_path    = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_context = var.kube_context
    config_path    = "~/.kube/config"
  }
}

/*
module "elasticsearch" {
  source = "../modules/elasticsearch"
}

module "grafeas" {
  source = "../modules/grafeas"

  elasticsearch_host     = module.elasticsearch.host
  elasticsearch_username = module.elasticsearch.username
  elasticsearch_password = module.elasticsearch.password

  depends_on = [
    module.elasticsearch
  ]
}
*/
module "nginx" {
  count  = var.enable_nginx ? 1 : 0
  source = "../modules/nginx"
}

module "harbor" {
  source = "../modules/harbor"

  host = var.harbor_host
}

module "coredns" {
  count  = var.enable_nginx ? 1 : 0
  source = "../modules/coredns"

  harbor_host       = var.harbor_host
  nginx_service_url = module.nginx[0].service_url

  depends_on = [
    module.nginx,
    module.harbor
  ]
}

module "jenkins" {
  source = "../modules/jenkins"

  harbor_namespace = module.harbor.namespace
  harbor_host      = var.harbor_host

  depends_on = [module.harbor]
}
