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