terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    pingone = {
      source = "pingidentity/pingone"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}



provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_environment_id
  region         = var.pingone_region
}
