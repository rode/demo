locals {
  policies  = yamldecode(templatefile("${path.module}/policies.yml", {
    harbor_policy    = file(abspath("${path.module}/policies/harbor.rego"))
    tfsec_policy     = file(abspath("${path.module}/policies/tfsec.rego"))
    sonarqube_policy = file(abspath("${path.module}/policies/sonarqube.rego"))
  }))
  rode_port = 50051
}

resource "kubernetes_namespace" "rode" {
  metadata {
    name        = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "helm_release" "rode" {
  name       = "rode"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode"
  repository = "https://rode.github.io/charts"
  version    = "0.3.0"
  wait       = true

  values = [
    templatefile("${path.module}/rode-values.yaml.tpl", {
      grafeas_namespace  = var.grafeas_namespace
      elasticsearch_host = var.elasticsearch_host
      rode_version       = var.rode_version

      oidc_auth_enabled           = var.oidc_auth_enabled
      oidc_auth_issuer            = var.oidc_issuer
      oidc_auth_required_audience = var.oidc_rode_client_id
      oidc_auth_role_claim_path   = var.oidc_auth_enabled ? "resource_access.${var.oidc_rode_client_id}.roles" : ""
    })
  ]
}

resource "kubernetes_ingress" "rode" {
  count = var.host == "" ? 0 : 1

  metadata {
    namespace = kubernetes_namespace.rode.metadata[0].name
    name      = "rode"
  }
  spec {
    backend {
      service_name = "rode"
      service_port = local.rode_port
    }

    rule {
      host = var.host

      http {
        path {
          path = "/"
          backend {
            service_name = "rode"
            service_port = local.rode_port
          }
        }
      }
    }

    tls {
      hosts = [
        var.host
      ]
    }
  }
}

resource "kubernetes_config_map" "policy" {
  metadata {
    name      = "rode-policy-configmap"
    namespace = kubernetes_namespace.rode.metadata[0].name
  }

  data = {
    "loadpolicy.sh" = templatefile("${path.module}/loadpolicy.sh.tpl", {
      policies       = local.policies
      rode_namespace = kubernetes_namespace.rode.metadata[0].name

      oidc_auth_enabled = var.oidc_auth_enabled
      oidc_token_url    = var.oidc_token_url
    })
  }
}

resource "kubernetes_secret" "auth_credentials" {
  count = var.oidc_auth_enabled ? 1 : 0

  metadata {
    name      = "rode-policy-auth-credentials"
    namespace = kubernetes_namespace.rode.metadata[0].name
  }

  data = {
    USERNAME      = var.oidc_admin_username
    PASSWORD      = var.oidc_admin_password
    CLIENT_ID     = var.oidc_rode_client_id
    CLIENT_SECRET = var.oidc_rode_client_secret
  }
}

resource "kubernetes_job" "load_policy" {
  metadata {
    name      = "rode-policy-creation"
    namespace = kubernetes_namespace.rode.metadata[0].name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "alpine"
          image   = "alpine"
          command = [
            "/bin/sh",
            "-c",
            "/root/loadpolicy.sh"
          ]
          volume_mount {
            name       = "policy-configmap-volume"
            mount_path = "/root/loadpolicy.sh"
            sub_path   = "loadpolicy.sh"
          }
          // if auth is enabled, populate the job with environment variables needed to authenticate policy creation API calls
          dynamic env_from {
            for_each = var.oidc_auth_enabled ? [0] : []
            content {
              secret_ref {
                name = kubernetes_secret.auth_credentials[0].metadata[0].name
              }
            }
          }
        }
        volume {
          name = "policy-configmap-volume"
          config_map {
            name         = "rode-policy-configmap"
            default_mode = "0777"
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true

  depends_on = [
    helm_release.rode,
    kubernetes_config_map.policy
  ]
}

resource "helm_release" "rode_ui" {
  name       = "rode-ui"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode-ui"
  repository = "https://rode.github.io/charts"
  version    = "0.3.0"
  wait       = true

  set_sensitive {
    name  = "rode.auth.oidc.clientSecret"
    value = var.oidc_rode_client_secret
  }

  values = [
    templatefile("${path.module}/rode-ui-values.yaml.tpl", {
      namespace       = kubernetes_namespace.rode.metadata[0].name
      rode_ui_version = var.rode_ui_version
      rode_ui_host    = var.rode_ui_host
      ingress_class   = var.ingress_class

      oidc_auth_enabled = var.oidc_auth_enabled
      oidc_client_id    = var.oidc_rode_client_id
      oidc_issuer       = var.oidc_issuer
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}

resource "helm_release" "rode_collector_build" {
  name       = "rode-collector-build"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  repository = "https://rode.github.io/charts"
  chart      = "rode-collector-build"
  version    = "0.2.0"
  wait       = true

  values = [
    templatefile("${path.module}/rode-collector-build-values.yaml.tpl", {
      namespace               = kubernetes_namespace.rode.metadata[0].name
      build_collector_version = var.build_collector_version
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}

resource "helm_release" "rode_collector_tfsec" {
  name       = "rode-collector-tfsec"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  repository = "https://rode.github.io/charts"
  chart      = "rode-collector-tfsec"
  version    = "0.1.0"
  wait       = true

  values = [
    templatefile("${path.module}/rode-collector-tfsec-values.yaml.tpl", {
      namespace               = kubernetes_namespace.rode.metadata[0].name
      tfsec_collector_version = var.tfsec_collector_version
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}

resource "kubernetes_ingress" "rode_collector_tfsec" {
  count = var.tfsec_collector_host == "" ? 0 : 1

  metadata {
    namespace = kubernetes_namespace.rode.metadata[0].name
    name      = "rode-collector-tfsec"
  }

  spec {
    rule {
      host = var.tfsec_collector_host

      http {
        path {
          path = "/"
          backend {
            service_name = "rode-collector-tfsec"
            service_port = 8083
          }
        }
      }
    }

    tls {
      hosts = [
        var.tfsec_collector_host
      ]
    }
  }
}
