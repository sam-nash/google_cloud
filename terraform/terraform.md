# Terraform

Refer to the terraform module in this repository and the attached screenshots to understand the steps involved.

Post apply the Worload Identity Federation section in Google Cloud displays the Pool, Provider details with t he attribute mapping and condition that was applied. Refer to the [WIF Pool Screenshot](WIF_Pool_Provider.png) and the [Providr Configuration](Attribute-Mapping-Condition.png)

## terraform.tfvars

```terraform
project_id                  = "gh-actions-1506"
region                      = "asia-southeast1"
zone                        = "asia-southeast1-a"
pool_id                     = "gh-pool"
pool_display_name           = "GitHub Pool"
provider_id                 = "gh-provider"
provider_display_name       = "GitHub Provider"
service_account_id          = "github-sa"
service_account_display_name = "Github-Actions-SA"
project_number              = "180855126385"
github_repository           = "sam-nash/gh-actions"
```

