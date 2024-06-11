
variable "google_organization" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "secops_tenant_url" {
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
  default = ""
}

variable "okta_base_url" {
  type = string
  default = ""
}

variable "okta_token" {
  type      = string
  sensitive = true
  default = ""
}

variable "pingone_client_id" {
  type = string
  default = "changeme1"
}

variable "pingone_client_secret" {
  type      = string
  sensitive = true
  default = "changeme"
}

variable "pingone_environment_id" {
  type = string
  default = "changeme"
}

variable "pingone_region" {
  type = string
  default = "NorthAmerica"

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
  default = ""
}

variable "azure_client_secret" {
  type      = string
  sensitive = true
  default = ""
}

variable "azure_tenant_id" {
  type = string
  default = ""
}


variable "azure_subscription_id" {
  type = string
  default = ""
}

