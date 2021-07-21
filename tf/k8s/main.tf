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

    random    = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    harbor    = {
      source  = "liatrio/harbor"
      version = "0.3.4"
    }
    sonarqube = {
      source  = "jdamata/sonarqube"
      version = "0.0.5"
    }

    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.2.0"
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
    config_path    = var.kube_config
  }
}

provider "keycloak" {
  client_id                = "admin-cli"
  username                 = "keycloak"
  password                 = var.enable_keycloak ? module.keycloak[0].keycloak_admin_password : ""
  url                      = var.enable_keycloak ? "https://${var.keycloak_host}" : ""
  tls_insecure_skip_verify = var.keycloak_tls_insecure_skip_verify
  initial_login            = false
}

provider "sonarqube" {
  host              = var.enable_sonarqube ? "https://${module.sonarqube[0].sonarqube_host}" : ""
  user              = var.enable_sonarqube ? module.sonarqube[0].sonarqube_username : ""
  pass              = var.enable_sonarqube ? module.sonarqube[0].sonarqube_password : ""
  installed_version = "8.5"
}

module "elasticsearch" {
  source                = "../modules/elasticsearch"
  namespace             = var.elasticsearch_namespace
  namespace_annotations = var.namespace_annotations

  replicas = var.elasticsearch_replicas
}

module "grafeas" {
  source = "../modules/grafeas"

  namespace              = var.grafeas_namespace
  namespace_annotations  = var.namespace_annotations
  elasticsearch_host     = module.elasticsearch.host
  elasticsearch_username = module.elasticsearch.username
  elasticsearch_password = module.elasticsearch.password

  grafeas_host    = var.grafeas_host
  grafeas_version = var.grafeas_version
}

module "rode" {
  source = "../modules/rode"

  host = var.rode_host

  namespace               = var.rode_namespace
  namespace_annotations   = var.namespace_annotations
  grafeas_namespace       = var.grafeas_namespace
  elasticsearch_host      = module.elasticsearch.host
  rode_ui_host            = var.rode_ui_host
  rode_ui_version         = var.rode_ui_version
  build_collector_version = var.build_collector_version
  rode_version            = var.rode_version
  tfsec_collector_host    = var.tfsec_collector_host
  tfsec_collector_version = var.tfsec_collector_version
  ingress_class           = var.ingress_class

  oidc_auth_enabled = var.enable_keycloak
  oidc_issuer       = var.enable_keycloak ? module.keycloak[0].issuer_url : ""
  oidc_token_url    = var.enable_keycloak ? module.keycloak[0].token_url : ""

  oidc_rode_client_id     = var.enable_keycloak ? module.keycloak[0].rode_client_id : ""
  oidc_rode_client_secret = var.enable_keycloak ? module.keycloak[0].rode_client_secret : ""

  oidc_admin_username = var.enable_keycloak ? module.keycloak[0].admin_username : ""
  oidc_admin_password = var.enable_keycloak ? module.keycloak[0].admin_password : ""

  depends_on = [
    module.grafeas
  ]
}

module "nginx" {
  count                 = var.enable_nginx ? 1 : 0
  source                = "../modules/nginx"
  namespace             = var.nginx_namespace
  namespace_annotations = var.namespace_annotations
}

module "harbor" {
  source = "../modules/harbor"

  namespace                = var.harbor_namespace
  namespace_annotations    = var.namespace_annotations
  host                     = var.harbor_host
  cert_source              = var.harbor_cert_source
  ingress_class            = var.ingress_class
  harbor_insecure          = var.harbor_insecure
  harbor_collector_version = var.harbor_collector_version
  rode_host                = module.rode.rode_internal_host

  oidc_auth_enabled  = var.enable_keycloak
  oidc_client_id     = var.enable_keycloak ? module.keycloak[0].service_account_client_id["collector"] : ""
  oidc_client_secret = var.enable_keycloak ? module.keycloak[0].service_account_client_secret["collector"] : ""
  oidc_token_url     = var.enable_keycloak ? module.keycloak[0].token_url : ""

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

module "demo_app_setup" {
  source = "../modules/demo-app-setup"

  environments     = var.environments
  harbor_host      = var.harbor_host
  harbor_namespace = var.harbor_namespace
  deploy_namespace = var.deploy_namespace

  depends_on = [
    module.harbor
  ]
}

module "sonarqube" {
  count  = var.enable_sonarqube ? 1: 0
  source = "../modules/sonarqube"

  host                        = var.sonarqube_host
  ingress_class               = var.ingress_class
  namespace                   = var.sonarqube_namespace
  namespace_annotations       = var.namespace_annotations
  rode_host                   = module.rode.rode_internal_host
  sonarqube_collector_version = var.sonarqube_collector_version

  oidc_auth_enabled  = var.enable_keycloak
  oidc_client_id     = var.enable_keycloak ? module.keycloak[0].service_account_client_id["collector"] : ""
  oidc_client_secret = var.enable_keycloak ? module.keycloak[0].service_account_client_secret["collector"] : ""
  oidc_token_url     = var.enable_keycloak ? module.keycloak[0].token_url : ""
}

module "sonarqube_config" {
  count  = var.enable_sonarqube ? 1 : 0
  source = "../modules/sonarqube-config"

  sonarqube_collector_url = module.sonarqube[0].sonarqube_collector_url
}

module "jenkins" {
  count  = var.enable_jenkins ? 1 : 0
  source = "../modules/jenkins"

  harbor_namespace      = module.harbor.namespace
  harbor_host           = var.harbor_host
  jenkins_host          = var.jenkins_host
  sonarqube_host        = var.sonarqube_host
  sonarqube_token       = var.enable_sonarqube ? module.sonarqube_config[0].sonarqube_token : ""
  rode_namespace        = var.rode_namespace
  namespace             = var.jenkins_namespace
  namespace_annotations = var.namespace_annotations
  ingress_class         = var.ingress_class
  deploy_namespace      = var.deploy_namespace
  environments          = var.environments

  oidc_client_id     = var.enable_keycloak ? module.keycloak[0].service_account_client_id["collector"] : ""
  oidc_client_secret = var.enable_keycloak ? module.keycloak[0].service_account_client_secret["collector"] : ""
  oidc_token_url     = var.enable_keycloak ? module.keycloak[0].token_url : ""

  depends_on = [
    module.nginx,
    module.harbor,
    module.demo_app_setup,
    module.sonarqube,
  ]
}

module "harbor_config" {
  source = "../modules/harbor-config"

  webhook_endpoint = "http://rode-collector-harbor.${var.harbor_namespace}.svc.cluster.local/webhook/event"
  depends_on       = [
    module.harbor
  ]
}

module "keycloak" {
  count  = var.enable_keycloak ? 1 : 0
  source = "../modules/keycloak"

  namespace_annotations = var.namespace_annotations
  ingress_class         = var.ingress_class
  keycloak_host         = var.keycloak_host
  rode_ui_host          = var.rode_ui_host
}
