locals {
  jenkins_plugins = [
    "job-dsl:1.77",
    "kubernetes-credentials-provider:0.15",
    "sonar:2.12"
  ]
}

resource "helm_release" "jenkins" {
  chart      = "jenkins"
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  version    = "2.13.1"
  namespace  = "harbor"

  set {
    name  = "master.additionalPlugins"
    value = "{${join(",", local.jenkins_plugins)}}"
  }
}

data "kubernetes_secret" "jenkins" {
  metadata {
    name      = "jenkins"
    namespace = "harbor"
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
    namespace = "harbor"
    labels    = {
      "${helm_release.jenkins.name}-jenkins-config" = "true"
    }
  }

  data = {
    "pipelines.yaml" = templatefile("${path.module}/pipelines.yaml.tpl", {
      pipelineOrg           = "rode"
      pipelineRepo          = "demo"
      credentialsSecretName = ""
    })
  }
}
