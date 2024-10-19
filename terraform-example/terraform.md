# How to Create Workload Identity Pool and Provider

In the absence of WIF we would ahve used the traditional methods of authentication would have involved exchanging credentials between GH and Googlke Cloud.  Workload Identity Federation eliminates this for us by allowing short-lived tokens issued by GitHub's identity provider which are then exchanged for Google Cloud's access tokens.

Step 1: Google Cloud Provider Configuration

Step 2: Enable the necessary Google Cloud APIs - IAM, Cloud Resource Manager, IAM Credentials, and STS

Step 3: Create a Workload Identity Pool

Step 4: Create a Workload Identity Provider within the pool

This resource allows you to configure an identity provider that can authenticate and authorize workloads running outside of Google Cloud, such as those in GitHub Actions, to access Google Cloud resources.

**oidc block**: This block configures the OpenID Connect (OIDC) settings for the provider. The issuer_uri is set to "<https://token.actions.githubusercontent.com>", indicating that the tokens issued by GitHub Actions will be trusted.

**attribute_mapping**: Attribute mapping defines how values are derived from an external token and mapped to the Google Security Token Service (STS) token attributes. The value for this parameter is a comma-separated list of mappings in the form of TARGET_ATTRIBUTE=SOURCE_EXPRESSION. In this case this attribute maps claims from the OIDC token to Google Cloud attributes. 

Claims in an OpenID Connect (OIDC) token are key-value pairs that provide information about the user or the entity that the token represents. These claims are used to convey identity information and other metadata.

For example, "google.subject" is mapped to "assertion.sub", which is the subject claim in the OIDC token. Other mappings include "attribute.actor", "attribute.repository", and "attribute.aud".

The sub (Subject) claim represents the unique identifier for the entity (e.g., a user or a service account) that the token is issued for.
In GitHub Actions, this might be the unique identifier for the workflow or job.
In Workload Identity Federation its mapped to google.subject, it helps Google Cloud identify the entity making the request.

The repository claim might represent the repository from which the action was triggered.
In GitHub Actions it indicates the specific GitHub repository involved in the workflow.
In Workload Identity Federation its mapped to attribute.repository, ensuring that only actions from specific repositories are trusted.

**attribute_condition**: This attribute sets a condition that must be met for the identity to be valid. This condition checks that the attribute.repository claim in the OIDC token matches the value of the var.github_repository variable, which is explicitly passed in the tfvars file. This adds an extra layer of security by ensuring that only workflows from a specific GitHub repository can access the Google Cloud resources.

Step 5: Create a service account

Step 6: Create an IAM binding for the above service account. A binding assigns a specific IAM role to a list of members (principals) for the service account. In simple words we are actualy granting permission to GitHub actions (coming from a specific GitHub repository) to use a Google Cloud service account.
This permission allows GitHub actions to act as the Google Cloud service account(service account impersonation) which is done by assigning the **iam.workloadIdentityUser** role, using Workload Identity Federation. This lets GitHub work with Google Cloud securely without needing to handle sensitive keys directly.

A **principal** represents an identity(can be an user/service account/group etc) that can be granted roles to access Google Cloud resources like VM/GKE, Storage etc.

For requests originating from outside GCP there must be a way to use their identity to impersonate a service account. A regular principal is the most basic way to identify an incoming request to Workload Identity Federation that essentially uses just the subject.
This is the default subject for an OIDC token issued in GitHub Actions.

For most purposes in github actions the principal configuration is sufficient for most common cases (single identity representing the GitHub Actions environment).

example: `principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/GCP_PROJECT_ID/subject/repo:${REPO}:ref:refs/heads/main`

PrincipalSet on the other hand involves a group of principals based on specific attributes or conditions. This becomes useful when there are multiple principals that share common characteristics.

for example a principalSet can be configured to include all identities from a particular GitHub organization using a workload identity pool in the format `principalSet://iam.googleapis.com/projects/${var.project_name}/locations/global/workloadIdentityPools/${var.provider_name}/attribute.repository_owner/${var.repository_owner}`

Principals are used when you want to grant permissions to specific, individual identities. This approach ensures tight control over access, as each identity must be explicitly defined.

Refer to the terraform module in this repository and the attached screenshots to understand the steps involved.
Post apply the Worload Identity Federation section in Google Cloud displays the Pool, Provider details witht he attribute mapping and condition that was applied. Refer to the [WIF Pool Screenshot](WIF_Pool_Provider.png) and the [Providr Configuration](Attribute-Mapping-Condition.png)

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

**Command to retrieve the Workload Identity Provider URI***

```shell
gcloud iam workload-identity-pools providers describe gh-provider \
  --project=gh-actions-1506 \
  --location="global" \
  --workload-identity-pool=gh-pool \
  --format="value(name)"
```

**Output**
```projects/180855126385/locations/global/workloadIdentityPools/gh-pool/providers/gh-provider```
