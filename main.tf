

resource "random_integer" "rand" {
  min = 1000
  max = 5000
}

locals {
  new_pool_id          = "${var.idp}-pool-${random_integer.rand.result}"
  new_pool_provider_id = "${var.idp}-provider-${random_integer.rand.result}"
  acs_url              = "https://auth.backstory.chronicle.security/signin-callback/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
  audience_url         = "https://iam.googleapis.com/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
  okta_enabled         = contains([var.idp], "okta") ? true : false
  azure_enabled        = contains([var.idp], "azure") ? true : false
  ping_enabled         = contains([var.idp], "ping") ? true : false
  idp                  = contains([var.idp], "okta") ? "okta" : contains([var.idp], "azure") ? "azure" : contains([var.idp], "ping") ? "ping" : false
}