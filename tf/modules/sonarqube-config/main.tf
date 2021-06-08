resource "sonarqube_webhook" "webhook" {
  name = "collector"
  url  = var.sonarqube_collector_url
}

resource "sonarqube_user_token" "admin_token" {
  name       = "token"
  login_name = "admin"
}
