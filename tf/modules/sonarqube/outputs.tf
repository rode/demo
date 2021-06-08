output "sonarqube_username" {
  value      = "admin"
  depends_on = [
    helm_release.sonarqube
  ]
}

output "sonarqube_password" {
  value      = random_password.admin_password.result
  sensitive  = true
  depends_on = [
    helm_release.sonarqube
  ]
}

output "sonarqube_host" {
  value      = var.host
  depends_on = [
    helm_release.sonarqube
  ]
}

output "sonarqube_collector_url" {
  value      = "http://rode-collector-sonarqube.${var.namespace}/webhook/event"
  depends_on = [
    helm_release.sonarqube
  ]
}
