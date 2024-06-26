data "google_organization" "org" {
  domain = var.google_organization
}

resource "google_project_service" "secops" {
  service = "chronicle.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_iam_workforce_pool" "secops" {
  workforce_pool_id = local.new_pool_id
  parent            = "organizations/${data.google_organization.org.org_id}"
  location          = "global"
  description       = "Workforce Pool for ${var.idp_app_label}"
  display_name      = local.new_pool_id
  disabled          = false
  access_restrictions {
    allowed_services {
      domain = "backstory.chronicle.security"
    }
    disable_programmatic_signin = false
  }
}

resource "google_iam_workforce_pool_provider" "secops" {
  workforce_pool_id = google_iam_workforce_pool.secops.workforce_pool_id
  location          = google_iam_workforce_pool.secops.location
  provider_id       = local.new_pool_provider_id
  display_name      = local.new_pool_provider_id
  description       = "Workforce Provider for ${var.idp_app_label}"
  disabled          = false

  attribute_mapping = {
    "google.subject"       = "assertion.subject"
    "attribute.first_name" = "assertion.attributes.first_name[0]"
    "attribute.user_email" = "assertion.attributes.emailaddress[0]"
    "attribute.last_name"  = "assertion.attributes.last_name[0]"
    "google.display_name"  = "assertion.attributes.name[0]"
    "google.groups"        = "assertion.attributes.groups"
  }

  saml {
    idp_metadata_xml = okta_app_saml.secops.metadata
  }
}

resource "google_organization_iam_member" "idp_groups" {
  for_each = {
    for k, v in var.idp_groups : k => v
  }
  org_id = data.google_organization.org.org_id
  role   = "roles/chronicle.${each.key}"
  member = "principalSet://iam.googleapis.com/locations/global/workforcePools/${local.new_pool_id}/group/${each.value}"
}

resource "google_project_iam_member" "default" {
  project = var.gcp_project_id
  role    = "roles/chronicle.limitedViewer"
  member  = "principalSet://iam.googleapis.com/locations/global/workforcePools/${local.new_pool_id}/*"
}

