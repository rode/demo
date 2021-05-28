output "rode_internal_host" {
  value = "rode.${helm_release.rode.namespace}.svc.cluster.local:${local.rode_port}"
}
