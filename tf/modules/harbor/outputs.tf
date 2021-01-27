output "harbor_host" {
  value = var.host
}

output "harbor_username" {
  value = "admin"
}

output "harbor_password" {
  value     = random_password.harbor_admin_password.result
  sensitive = true
}
