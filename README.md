# Terraforming Google SecOps (BYOP + BYOID)

This project sets up the necessary resources in GCP and a 3rd party IdP during Google SecOps (formerly Chronicle) onboarding for BYOP + BYOID. The intent is to make it easier for CEs, Partners, and customers to get SecOps auth up and running quickly using IaC (Terraform).

This should be run after your SecOps tenant has been provisioned by Google.

### Resources created:

`gcp.tf` (in your own project configured for SecOps)

- enable SecOps API
- Create IAM Workforce Pool
- Create IAM Workforce Pool Provider
- Attach IdP metadata to Workforce Pool Provider
    - Okta: programmatically via resource block
    - PingOne: via exported metadata.xml local file
- Assign admin/editor/viewer permissions to the IdP groups
- Assign role chronicle.limitedViewer so users can access UI

Each idp.tf (`okta.tf`, `pingone.tf`) does the following:
- Creates SAML application
- Creates IdP groups (admins, editor, viewer)
- Sets attribute mappings for users
- Grants IdP groups access to the application

## Requirements

- Active SecOps subscription

- GCP project configured for Google SecOps:
    - [GCP Console Instructions](https://cloud.google.com/chronicle/docs/onboard/configure-cloud-project)
    - Terraform example

- Credentials from an in-scope 3rd party Identity Provider (IdP):
    - [Okta](https://help.okta.com/en-us/content/topics/security/api.htm?cshid=ext-create-api-token#create-okta-api-token)
    - [PingOne](https://terraform.pingidentity.com/getting-started/pingone/)
    - AzureAD (coming soon)

- Any flavor of Terraform (pick one):
    - CLI (this project was tested with Terraform CLI v1.5.7)
    - Terraform Cloud
    - Terraform Enterprise

## Usage

1. Clone this repo.

1. Navigate to the directory for your desired IdP & follow the configuration instructions in the README within that directory.