
variable "google_organization" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "secops_tenant_url" {
  type = string
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
