output "username" {
  value = local.elasticsearch_username
}

output "password" {
  value = random_password.elasticsearch_password.result
}

output "host" {
  value = "elasticsearch-master.${kubernetes_namespace.elasticsearch.metadata[0].name}.svc.cluster.local:9200"
}

output "namespace" {
  value = kubernetes_namespace.elasticsearch.metadata[0].name
}
