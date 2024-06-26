# Terraforming Google SecOps (BYOP + BYOID)

This section sets up the necessary resources in GCP and PingOne IdP during Google SecOps (formerly Chronicle) onboarding for BYOP + BYOID.

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


## Important Notes


### IdP Metadata

PingOne does not support programmatically retrieving the metadata for an application via Terraform, so it must be [downloaded manually](https://docs.pingidentity.com/r/en-us/pingone/p1_t_downloadidpmetadataapps) after the first run and placed into this projects root directory as `metadata.xml`. Then, Terraform Apply needs to be run a second time.


## Requirements

- Active SecOps subscription

- GCP project configured for Google SecOps:
    - [GCP Console Instructions](https://cloud.google.com/chronicle/docs/onboard/configure-cloud-project)
    - Terraform example

- Credentials for PingOne:
    - [Instructions](https://terraform.pingidentity.com/getting-started/pingone/)
    - AzureAD (coming soon)

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

### PingOne

<details>
<summary>Click to expand</summary>

<br>1. Follow the [instructions](https://terraform.pingidentity.com/getting-started/pingone/) to create a worker application for Terraform and generate credentials.
<br>
2. Set the appropriate values for the respective PingOne variables: 

Variable | Description | Example
-- | -- | --
pingone_client_id | Client ID for the worker app client.  | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx
pingone_client_secret | Client secret for the worker app client.  | xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
pingone_environment_id | Environment ID for the worker app client. | xxxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx
pingone_region | The PingOne region to use. Options are `AsiaPacific` `Canada` `Europe` and `NorthAmerica`.  | NorthAmerica

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
3. Test login via PingOne or:

    ```html
    https://<tenanturl>.backstory.chronicle.security
    ```

### NOTE: PingOne Only

After the first successful run, [download the metadata file](https://docs.pingidentity.com/r/en-us/pingone/p1_t_downloadidpmetadataapps) and save it in the root directory of this project as `metadata.xml`. Then run:

```terraform
terraform init <press enter>

terraform plan <press enter>

terraform apply --auto-approve <press enter>
```