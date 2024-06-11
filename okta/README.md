# Terraforming Google SecOps (BYOP + BYOID) - Okta

This section sets up the necessary resources in GCP and Okta during Google SecOps (formerly Chronicle) onboarding for BYOP + BYOID. 

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

`okta.tf` does the following:
- Creates SAML application
- Creates IdP groups (admins, editor, viewer)
- Sets attribute mappings for users
- Grants IdP groups access to the application


## Important Notes


### IdP Groups

If modifying the IdP groups from the default (var.idp_groups), you must also update the filter_value attribute statement in `okta.tf` to match your desired group prefixes:

```  attribute_statements {
    name         = "groups"
    type         = "GROUP"
    filter_type  = "CONTAINS"
    filter_value = "google_secops" <--update this
  }
```

## Requirements

- Active SecOps subscription

- GCP project configured for Google SecOps:
    - [GCP Console Instructions](https://cloud.google.com/chronicle/docs/onboard/configure-cloud-project)
    - Terraform example

- Credentials for Okta):
    - [Instructions](https://help.okta.com/en-us/content/topics/security/api.htm?cshid=ext-create-api-token#create-okta-api-token)

- Any flavor of Terraform (pick one):
    - CLI (this project was tested with Terraform CLI v1.5.7)
    - Terraform Cloud
    - Terraform Enterprise


## Configuration

### GCP

<details>
<summary>Click to expand</summary>
<br>   
1. Authenticate with GCP:

- the easiest way is via gcloud:
    - `gcloud auth application-default login`
        - this should be run where you're running Terraform
- other methods, such as service account impersonation, Terraform Cloud environment variables, and more can be found in the [provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication)

<br>   
2. Set the appropriate values for the respective GCP and SecOps variables: 
<br>
<br>

Variable | Description | Example
-- | -- | --
google_organization | This is the org name of GCP Organization.  | acmecorp.com
gcp_project_id | ID of the project configured for SecOps. | acmecorp-chronicle 
secops_tenant_url | URL of your SecOps tenant | https://acmecorp.backstory.chronicle.security


</details>

### Okta

<details>
<summary>Click to expand</summary>
<br>   
Set the appropriate values for the respective Okta variables: 
<br>
<br>

Variable | Description | Example
-- | -- | --
okta_org_name | This is the org name of your Okta account.  | dev-123456.oktapreview.com would have an org name of `dev-12345`.
okta_base_url | This is the domain of your Okta account. | dev-123456.oktapreview.com would have a base url of `oktapreview.com`.
okta_token | This is the API token to interact with your Okta org. | 00I_2kmj1kk345jj2m2k32

</details>

## Usage

1. Clone this repo.

1. Input the appropriate variable values in your own variables file (example is provided in `variables.auto.tfvars.example`)

1. Run the following Terraform commands:

    ```terraform
    terraform init <press enter>

    terraform plan <press enter>

    terraform apply --auto-approve <press enter>
    ```

1. After the plan finishes applying, have your Customer Engineer or Partner Engineer run these commands to update the frontend path:

    ```
    cm_cli customer update_provider_id {{CUSTOMER_ID}} {{CUSTOMER_FRONTEND_PATH}} locations/global/workforcePools/{{WORKFORCE_POOL}}/providers/{{WORKFORCE_PROVIDER_ID}} --env=prod --region={{REGION}}
    ```
    ```
    cm_cli customer migrate_sso_config {{CUSTOMER_ID}} --use_byoid_auth=true --env=prod --region={{REGION}}
    ```
3. Test login via Okta or:

    ```html
    https://<tenanturl>.backstory.chronicle.security
    ```