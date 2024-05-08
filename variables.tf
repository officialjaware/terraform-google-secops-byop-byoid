
variable "google_organization" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "chronicle_tenant_url" {
  type = string
}

variable "idp" {
  type = string

  validation {
    condition     = contains(["okta", "pingone", "azure"], var.idp)
    error_message = "ERROR: Valid values for var.idp are \"okta\", \"pingone\", \"azure\""
  }
}

variable "okta_org_name" {
  type = string
}

variable "okta_base_url" {
  type = string
}

variable "okta_token" {
  type      = string
  sensitive = true
}

variable "pingone_client_id" {
  type = string
}

variable "pingone_client_secret" {
  type      = string
  sensitive = true
}

variable "pingone_environment_id" {
  type = string
}

variable "pingone_region" {
  type = string

  validation {
    condition     = contains(["AsiaPacific", "Canada", "Europe", "NorthAmerica"], var.pingone_region)
    error_message = "ERROR: Valid values for var.pingone_region are \"AsiaPacific\", \"Canada\", \"Europe\", \"NorthAmerica\""
  }
}

variable "idp_app_label" {
  type    = string
  default = "Google SecOps"
}

variable "idp_groups" {
  type = object({
    admin  = string
    editor = string
    viewer = string
  })
}

variable "azure_client_id" {
  type = string
}

variable "azure_client_secret" {
  type      = string
  sensitive = true
}

variable "azure_tenant_id" {
  type = string
}


variable "azure_subscription_id" {
  type = string
}

