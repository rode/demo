output "namespace" {
  value = kubernetes_namespace.harbor.metadata[0].name
}
