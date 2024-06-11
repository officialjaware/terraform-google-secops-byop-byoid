

resource "random_integer" "rand" {
  min = 1000
  max = 5000
}

locals {
  new_pool_id          = "okta-pool-${random_integer.rand.result}"
  new_pool_provider_id = "okta-provider-${random_integer.rand.result}"
  acs_url              = "https://auth.backstory.chronicle.security/signin-callback/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
  audience_url         = "https://iam.googleapis.com/locations/global/workforcePools/${local.new_pool_id}/providers/${local.new_pool_provider_id}"
}