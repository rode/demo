resource "kubernetes_namespace" "harbor" {
  metadata {
    name        = var.namespace
    annotations = var.namespace_annotations
  }
}

resource "random_password" "harbor_admin_password" {
  length  = 12
  special = false
}

resource "random_password" "harbor_registry_password" {
  length  = 12
  special = false
}

locals {
  harbor_registry_user = "harbor_registry_user"
}

resource "helm_release" "harbor" {
  name       = "harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  chart      = "harbor"
  repository = "https://helm.goharbor.io"
  version    = "1.5.3"
  wait       = true

  set_sensitive {
    name  = "harborAdminPassword"
    value = random_password.harbor_admin_password.result
  }

  set_sensitive {
    name  = "registry.credentials.password"
    value = random_password.harbor_registry_password.result
  }

  set_sensitive {
    name  = "registry.credentials.htpasswd"
    value = "${local.harbor_registry_user}:${bcrypt(random_password.harbor_registry_password.result)}"
  }

  lifecycle {
    ignore_changes = [
      set_sensitive
    ]
  }

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      harbor_host        = var.host
      harbor_cert_source = var.cert_source
      registry_user      = local.harbor_registry_user
      ingress_class      = var.ingress_class
    })
  ]
}

resource "helm_release" "rode_collector_harbor" {
  name       = "rode-collector-harbor"
  namespace  = kubernetes_namespace.harbor.metadata[0].name
  chart      = "rode-collector-harbor"
  repository = "https://rode.github.io/charts"
  version    = "0.1.0"
  wait       = true

  set_sensitive {
    name  = "harbor.password"
    value = random_password.harbor_admin_password.result
  }

  values = [
    templatefile("${path.module}/rode-collector-harbor-values.yaml.tpl", {
      rode_host                = var.rode_host
      harbor_url               = "https://${var.host}"
      harbor_username          = "admin"
      harbor_insecure          = var.harbor_insecure
      harbor_collector_version = var.harbor_collector_version
    })
  ]
}
