locals {
  attribute_mappings = [
    {
      name     = "saml_subject"
      value    = "$${user.email}"
      required = true
    },
    {
      name  = "name"
      value = "$${user.name.given + \" \" + user.name.family}"
    },
    {
      name  = "first_name"
      value = "$${user.name.given}"
    },
    {
      name  = "last_name"
      value = "$${user.name.family}"
    },
    {
      name  = "email"
      value = "$${user.email}"
    },
    {
      name  = "groups"
      value = "$${user.memberOfGroupNames}"
    }
  ]
}

resource "pingone_application" "secops" {
  count = var.idp == "pingone" ? 1 : 0

  environment_id = var.pingone_environment_id
  name           = var.idp_app_label
  enabled        = true

  saml_options {
    acs_urls           = [local.acs_url]
    assertion_duration = 300
    nameid_format      = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
    sp_entity_id       = local.audience_url
    default_target_url = var.secops_tenant_url
    response_is_signed = true
  }

  access_control_group_options {
    groups = [
      for key, group_name in var.idp_groups : pingone_group.secops[key].id
    ]
    type = "ANY_GROUP"
  }
}


resource "pingone_application_attribute_mapping" "secops" {
  count          = var.idp == "pingone" ? length(local.attribute_mappings) : 0
  environment_id = var.pingone_environment_id
  application_id = pingone_application.secops[0].id

  name     = local.attribute_mappings[count.index].name
  value    = local.attribute_mappings[count.index].value
  required = local.attribute_mappings[count.index].name == "saml_subject" ? true : null
}

resource "pingone_group" "secops" {
  for_each = {
    for k, v in var.idp_groups : k => v
    if var.idp == "pingone"
  }

  environment_id = var.pingone_environment_id
  name           = each.value
  description    = "Grants access to ${var.idp_app_label} using the prebuilt default ${title(each.key)} role"

}