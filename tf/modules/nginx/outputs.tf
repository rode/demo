output "service_url" {
  value = "${helm_release.nginx.name}-controller.${kubernetes_namespace.nginx.metadata[0].name}.svc.cluster.local"
}
