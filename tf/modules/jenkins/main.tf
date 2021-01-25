data "kubernetes_secret" "harbor_auth" {
  metadata {
    name      = "harbor-harbor-registry"
    namespace = "harbor"
  }
}

resource "kubernetes_secret" "jenkins_docker_config" {
  metadata {
    name      = "jenkins-docker-config"
    namespace = "harbor"
  }

  data = {
    "config.json" = templatefile("${path.module}/dockercfg.tpl", {
      email = "admin@liatr.io"
      url   = "http://${var.harbor_host}:5000"
      auth  = kubernetes_secret.harbor_auth.data.REGISTRY_HTPASSWD //harbor-harbor-registry secret 
    })
  }

  type = "Opaque"
}

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
