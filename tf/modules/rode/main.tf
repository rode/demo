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
  version    = "0.2.0"
  wait       = true

  values = [
    templatefile("${path.module}/rode-values.yaml.tpl", {
      grafeas_namespace  = var.grafeas_namespace
      elasticsearch_host = var.elasticsearch_host
      rode_version       = var.rode_version
    })
  ]
}

resource "kubernetes_ingress" "rode" {
  count = var.host == "" ? 0 : 1

  metadata {
    namespace   = kubernetes_namespace.rode.metadata[0].name
    name        = "rode"
    annotations = {
      "nginx.ingress.kubernetes.io/backend-protocol" = "GRPC"
    }
  }
  spec {
    backend {
      service_name = "rode"
      service_port = 50051
    }

    rule {
      host = var.host

      http {
        path {
          path = "/"
          backend {
            service_name = "rode"
            service_port = 50051
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
      policy_data    = tostring(jsonencode(yamldecode(file("${path.module}/policy.yml"))))
      rode_namespace = kubernetes_namespace.rode.metadata[0].name
    })
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
            "/root/loadpolicy.sh"]
          volume_mount {
            name       = "policy-configmap-volume"
            mount_path = "/root/loadpolicy.sh"
            sub_path   = "loadpolicy.sh"
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

resource "helm_release" "rode_collector_harbor" {
  name       = "rode-collector-harbor"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode-collector-harbor"
  repository = "https://rode.github.io/charts"
  version    = "0.0.3"
  wait       = true

  set_sensitive {
    name  = "harbor.password"
    value = var.harbor_password
  }

  values = [
    templatefile("${path.module}/rode-collector-harbor-values.yaml.tpl", {
      namespace       = kubernetes_namespace.rode.metadata[0].name
      harbor_url      = var.harbor_url
      harbor_username = var.harbor_username
      harbor_insecure = var.harbor_insecure
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}

resource "helm_release" "rode_ui" {
  name       = "rode-ui"
  namespace  = kubernetes_namespace.rode.metadata[0].name
  chart      = "rode-ui"
  repository = "https://rode.github.io/charts"
  version    = "0.2.0"
  wait       = true

  values = [
    templatefile("${path.module}/rode-ui-values.yaml.tpl", {
      namespace       = kubernetes_namespace.rode.metadata[0].name
      rode_ui_version = var.rode_ui_version
      rode_ui_host    = var.rode_ui_host
      ingress_class   = var.ingress_class
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
    })
  ]

  depends_on = [
    helm_release.rode
  ]
}
