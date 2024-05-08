

output "workforce_pool" {
  value = local.new_pool_id
}

output "workforce_provider" {
  value = local.new_pool_provider_id
}

output "frontend_path" {
  value = regex("([^https://].*[^.backstory.chronicle.security])", var.chronicle_tenant_url)
}