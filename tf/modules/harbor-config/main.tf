resource "harbor_project" "project" {
  name      = "rode-demo"
  auto_scan = true
}

resource "harbor_webhook" "webhook" {
  project_id  = harbor_project.project.id
  name        = "Rode"
  event_types = ["SCANNING_COMPLETED", "SCANNING_FAILED"]
  target {
    type    = "http"
    address = var.webhook_endpoint
  }
}
