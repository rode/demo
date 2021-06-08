resource "sonarqube_webhook" "webhook" {
  name = "collector"
  url  = var.sonarqube_collector_url
}

resource "sonarqube_user_token" "admin_token" {
  name       = "token"
  login_name = "admin"
}

resource "sonarqube_project" "rode_demo_app" {
  name       = "rode:demo-app"
  project    = "rode:demo-app"
  visibility = "public"
}

resource "sonarqube_qualitygate" "no_vulns" {
  name = "No Code Vulnerabilities"
}

resource "sonarqube_qualitygate_condition" "no_vulns" {
  gatename  = sonarqube_qualitygate.no_vulns.id
  metric    = "vulnerabilities"
  threshold = "0"
  op        = "GT"
}

resource "sonarqube_qualitygate_project_association" "rode_no_vulns" {
  gatename   = sonarqube_qualitygate.no_vulns.id
  projectkey = sonarqube_project.rode_demo_app.project
}
