terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.0.3"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    harbor = {
      source  = "liatrio/harbor"
      version = "0.3.4"
    }
  }
}

provider "kubernetes" {
  config_context = var.kube_context
  config_path    = var.kube_config
}

provider "harbor" {
  url                      = "https://${module.harbor.harbor_host}"
  username                 = module.harbor.harbor_username
  password                 = module.harbor.harbor_password
  tls_insecure_skip_verify = true
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
}

module "rode" {
  source = "../modules/rode"

  host = var.rode_host

  harbor_url         = "https://${var.harbor_host}"
  harbor_password    = module.harbor.harbor_password
  harbor_username    = module.harbor.harbor_username
  harbor_insecure    = var.harbor_insecure
  namespace          = "rode-demo"
  grafeas_namespace  = "rode-demo-grafeas"
  elasticsearch_host = module.elasticsearch.host
  rode_ui_host       = var.rode_ui_host
  rode_ui_version    = var.rode_ui_version

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

  depends_on = [
    module.nginx
  ]
}

module "coredns" {
  count  = var.enable_nginx && var.update_coredns ? 1 : 0
  source = "../modules/coredns"

  harbor_host       = var.harbor_host
  nginx_service_url = module.nginx[0].service_url

  depends_on = [
    module.nginx,
    module.harbor
  ]
}

module "jenkins" {
  count  = var.enable_jenkins ? 1 : 0
  source = "../modules/jenkins"

  jenkins_host     = var.jenkins_host
  harbor_namespace = module.harbor.namespace
  harbor_host      = var.harbor_host

  depends_on = [
    module.nginx,
    module.harbor
  ]
}

module "harbor_config" {
  source = "../modules/harbor-config"

  webhook_endpoint = "http://rode-collector-harbor.rode-demo.svc.cluster.local/webhook/event"
  depends_on = [
    module.harbor
  ]
}
