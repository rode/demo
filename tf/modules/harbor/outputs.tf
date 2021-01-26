output "namespace" {
  value = kubernetes_namespace.harbor.metadata[0].name
}

output "registry_user" {
  value = local.harbor_registry_user
}

output "registry_pass" {
  value = random_password.harbor_registry_password.result
}

output "registry_host" {
  value = "${helm_release.harbor.name}-harbor-registry.${kubernetes_namespace.harbor.metadata[0].name}.svc.cluster.local"
}
