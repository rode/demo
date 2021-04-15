resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_namespace" "deploy" {
  metadata {
    name = var.deploy_namespace
  }
}

data "kubernetes_secret" "harbor_auth" {
  metadata {
    name      = "harbor-harbor-core"
    namespace = var.harbor_namespace
  }
}

resource "kubernetes_secret" "jenkins_docker_config" {
  metadata {
    name      = "jenkins-docker-config"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  data = {
    "config.json" = templatefile("${path.module}/dockercfg.tpl", {
      email = "admin@liatr.io"
      url   = "https://${var.harbor_host}"
      auth  = base64encode("admin:${data.kubernetes_secret.harbor_auth.data.HARBOR_ADMIN_PASSWORD}")
    })
  }

  type = "Opaque"
}

locals {
  jenkins_plugins = [
    "job-dsl:1.77",
    "kubernetes-credentials-provider:0.17",
    "sonar:2.13"
  ]
}

resource "helm_release" "jenkins" {
  chart      = "jenkins"
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  version    = "3.3.0"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  set {
    name  = "controller.additionalPlugins"
    value = "{${join(",", local.jenkins_plugins)}}"
  }

  values = [
    templatefile("${path.module}/values.yaml.tpl", {
      jenkins_host = var.jenkins_host
      ingress_class = var.ingress_class
    })
  ]
}

data "kubernetes_secret" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  depends_on = [
    helm_release.jenkins
  ]
}

output "jenkins_admin_password" {
  value = data.kubernetes_secret.jenkins.data.jenkins-admin-password
}

resource "kubernetes_config_map" "jcasc_pipelines" {
  metadata {
    name      = "${helm_release.jenkins.name}-jcasc-pipelines"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
    labels = {
      "${helm_release.jenkins.name}-jenkins-config" = "true"
    }
  }

  data = {
    "pipelines.yaml" = templatefile("${path.module}/pipelines.yaml.tpl", {
      pipelineOrg           = "rode"
      pipelineRepo          = "demo-app"
      credentialsSecretName = ""
    })
  }
}
