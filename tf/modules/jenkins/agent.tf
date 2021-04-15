resource "kubernetes_service_account" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-master"
      "app.kubernetes.io/managed-by" = "Terraform"
    }

    annotations = {
      description = "Service account for Jenkins Agent"
      source-repo = "https://github.com/rode/demo"
    }
  }

  automount_service_account_token = true
}

// Add role permissions for Jenkins Agents
resource "kubernetes_role" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = var.deploy_namespace

    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-master"
      "app.kubernetes.io/managed-by" = "Terraform"
    }

    annotations = {
      description = "Permission required for Jenkins agents"
      source-repo = "https://github.com/rode/demo"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["services", "configmaps", "secrets", "namespaces", "serviceaccounts"]
    verbs      = ["*"]
  }

  rule {
    api_groups = ["apps"]
    resources = ["deployments", "statefulsets", "replicasets"]
    verbs = ["*"]
  }
  rule {
    api_groups = ["networking.k8s.io"]
    resources = ["ingresses"]
    verbs = ["*"]
  }
  rule {
    api_groups = ["policy"]
    resources = ["poddisruptionbudgets"]
    verbs = ["*"]
  }
  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources = ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
    verbs = ["*"]
  }

}

// Bind Kubernetes secrets role to Jenkins service account
resource "kubernetes_role_binding" "jenkins_agent" {
  metadata {
    name      = "jenkins-agent"
    namespace = var.deploy_namespace

    labels = {
      "app.kubernetes.io/name"       = "jenkins"
      "app.kubernetes.io/instance"   = "jenkins"
      "app.kubernetes.io/component"  = "jenkins-master"
      "app.kubernetes.io/managed-by" = "Terraform"
    }

    annotations = {
      description = "Permission required for Jenkins Agents"
      source-repo = "https://github.com/rode/demo"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.jenkins_agent.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.jenkins_agent.metadata[0].name
    namespace = var.namespace
  }
}

