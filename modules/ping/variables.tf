

variable "secops_tenant_url" {
  type = string
}

variable "idp" {
  type = string
}

variable "acs_url" {
  type = string
}

variable "audience_url" {
  type = string
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