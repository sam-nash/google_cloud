# How to Create Wirkload Identity Pool and Provider

Refer to the terraform module to understand the steps involved.
Post apply the Worload Identity Federation section in Google Cloud displays the Pool, Provider details witht he attribute mapping and condition that was applied.

## terraform.tfvars
```
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

**Command to retrieve the Workload Identity Provider URI***

```
gcloud iam workload-identity-pools providers describe gh-provider \
  --project=gh-actions-1506 \
  --location="global" \
  --workload-identity-pool=gh-pool \
  --format="value(name)"
```

**Output**
```projects/180855126385/locations/global/workloadIdentityPools/gh-pool/providers/gh-provider```

