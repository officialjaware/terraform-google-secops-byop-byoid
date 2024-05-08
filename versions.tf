terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    okta = {
      source = "okta/okta"
    }
    random = {
      source = "hashicorp/random"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
    pingone = {
      source = "pingidentity/pingone"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = var.okta_base_url
  api_token = var.okta_token
}

provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_environment_id
  region         = var.pingone_region
}

provider "azuread" {

  #client_id     = var.azure_client_id
  #client_secret = var.azure_client_secret
  tenant_id = var.azure_tenant_id
  #subscription_id = var.azure_subscription_id
}