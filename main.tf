

resource "random_integer" "rand" {
  min = 1000
  max = 5000
}

locals {
  new_pool_id          = "${var.idp}-pool-${random_integer.rand.result}"
  new_pool_provider_id = "${var.idp}-provider-${random_integer.rand.result}"
  acs_url              = "https://auth.backstory.chronicle.security/signin-callback/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
  audience_url         = "https://iam.googleapis.com/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
  idp                  = contains([var.idp], "okta") ? "okta" : contains([var.idp], "azure") ? "azure" : contains([var.idp], "ping") ? "ping" : false
}

module "okta" {
  source = "./modules/okta"
  idp = var.idp
  okta_base_url = var.okta_base_url
  okta_org_name = var.okta_org_name
  okta_token = var.okta_token
  acs_url = local.acs_url
  audience_url = local.audience_url
  secops_tenant_url = var.secops_tenant_url
  new_pool_id = local.new_pool_id
  new_pool_provider_id = local.new_pool_provider_id
  idp_groups = var.idp_groups
}

module "pingone" {
  source = "./modules/ping"
  idp = var.idp
  acs_url = local.acs_url
  audience_url = local.audience_url
  secops_tenant_url = var.secops_tenant_url
  idp_groups = var.idp_groups
  pingone_client_id = var.pingone_client_id
  pingone_client_secret = var.pingone_client_id
  pingone_environment_id = var.pingone_environment_id
  pingone_region = var.pingone_region
}