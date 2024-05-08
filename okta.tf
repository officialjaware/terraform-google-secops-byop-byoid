locals {
  attribute_statements = {
    subject      = "user.email"
    name         = "user.firstName + \" \" + user.lastName"
    first_name   = "user.firstName"
    last_name    = "user.lastName"
    emailaddress = "user.email"
  }
}

resource "okta_app_saml" "chronicle" {
  count = var.idp == "okta" ? 1 : 0

  label               = var.idp_app_label
  logo                = "${path.module}/secops_logo.png"
  sso_url             = local.acs_url
  default_relay_state = var.chronicle_tenant_url
  audience            = local.audience_url
  recipient           = local.acs_url
  destination         = local.acs_url
  #subject_name_id_template = "$${user.userEmail}"
  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  user_name_template       = "$${source.email}"
  response_signed          = true
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = true
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  attribute_statements {
    name         = "groups"
    type         = "GROUP"
    filter_type  = "CONTAINS"
    filter_value = "chronicle_secops"
  }

  dynamic "attribute_statements" {
    for_each = local.attribute_statements
    content {
      name   = attribute_statements.key
      values = [attribute_statements.value]
    }
  }

}

resource "okta_group" "chronicle" {
  for_each = {
    for k, v in var.idp_groups : k => v
    if var.idp == "okta"
  }

  name        = each.value
  description = "Grants access to ${var.idp_app_label} using the prebuilt default ${title(each.key)} role"
}

resource "okta_app_group_assignment" "chronicle" {
  for_each = {
    for k, v in var.idp_groups : k => v
    if var.idp == "okta"
  }

  app_id   = okta_app_saml.chronicle[0].id
  group_id = okta_group.chronicle[each.key].id
}