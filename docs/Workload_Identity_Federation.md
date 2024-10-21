# Workload Identity Federation

In modern cloud environments, managing credentials securely and efficiently is crucial. Workload Identity Federation (WIF) is a feature provided by Google Cloud that allows you to securely access Google Cloud resources without needing to manage long-lived service account keys. This README will guide you through understanding what Workload Identity Federation is, why it's needed, and how to set it up.

The examples in this documentation will demonstrate how the terraform changes to set up GCP Resources changes in one GitHub repository can trigger a GitHub Action in another repository to apply a Terraform plan.

## What is Workload Identity Federation?

Workload Identity Federation allows you to grant identities from external identity providers (such as AWS, Azure, or GitHub) access to Google Cloud resources. Instead of using long-lived service account keys, you can use short-lived, automatically rotated tokens. This enhances security by reducing the risk of key leakage and simplifies credential management.

## Why Use Workload Identity Federation?

*Enhanced Security:* Reduces the risk of key leakage by using short-lived tokens.
*Simplifies Credential Management:* No need to manage and rotate long-lived service account keys.
*Seamless Integration:* Easily integrates with external identity providers like AWS, Azure, and GitHub.

Pre-Requisites : The examples in this documentation will make use of terraform to create GCP resources. Please ensure the required APIs are enalbed and a Google Storage Bucjet is created to manage terraform state.

## Setting Up Workload Identity Federation

Step 1: Create a Workload Identity Pool

**UI**
Navigate to the IAM & Admin section in the Google Cloud Console.
Select Workload Identity Pools and click Create Pool.
Provide a name and description for the pool.
Click Create to create the pool.
**Console**

   ```sh
   gcloud iam workload-identity-pools create "gh-actions-pool" \
       --project="gh-actions-1506" \
       --location="global" \
       --display-name="GitHub Actions Pool"
   ```

Step 2: Create a Workload Identity Provider

**UI**
Select the Workload Identity Pool you created.
Click Add Provider.
Select the identity provider type (e.g., OIDC for GitHub).
Provide the necessary details (e.g., issuer URL, audience).
Click Create to create the provider.
**Console**

   ```sh
    gcloud iam workload-identity-pools providers create-oidc "gh-actions-provider" \
    --project="gh-actions-1506" \
    --location=global \
    --workload-identity-pool="gh-actions-pool" \
    --display-name="GitHub Actions Provider" \
    --issuer-uri="https://token.actions.githubusercontent.com" \
    --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
    --attribute-condition="attribute.repository=='sam-nash/gh-actions'"
   ```

**oidc block**: This block configures the OpenID Connect (OIDC) settings for the provider. The issuer_uri is set to "<https://token.actions.githubusercontent.com>", indicating that the tokens issued by GitHub Actions will be trusted.
The create-oidc sub-command indicates that we want to create an OpenID Connect (OIDC) provider in our pool. GitHub uses OIDC to authenticate with different cloud providers (see GitHub documentation on it here). The issuer-uri parameter specifies the provider URL, as indicated by GitHub’s OIDC documentation.

**attribute mapping**:
The --attribute-mapping parameter lists our attribute mapping. Attribute mapping defines how values are derived from an external token and mapped to the Google Security Token Service (STS) token attributes. The value for this parameter is a comma-separated list of mappings in the form of TARGET_ATTRIBUTE=SOURCE_EXPRESSION. These attributes will be referenced later when we set up permissions.
Learn more about attribute mapping from Google Cloud’s documentation on workload identity federation.

Claims in an OpenID Connect (OIDC) token are key-value pairs that provide information about the user or the entity that the token represents. These claims are used to convey identity information and other metadata.

For example, "google.subject" is mapped to "assertion.sub", which is the subject claim in the OIDC token. Other mappings include "attribute.actor", "attribute.repository", and "attribute.aud".

The sub (Subject) claim represents the unique identifier for the entity (e.g., a user or a service account) that the token is issued for.
In GitHub Actions, this might be the unique identifier for the workflow or job.
In Workload Identity Federation its mapped to google.subject, it helps Google Cloud identify the entity making the request.

The repository claim might represent the repository from which the action was triggered.
In GitHub Actions it indicates the specific GitHub repository involved in the workflow.
In Workload Identity Federation its mapped to attribute.repository, ensuring that only actions from specific repositories are trusted.

**attribute condition**: This attribute sets a condition that must be met for the identity to be valid. This condition checks that the attribute.repository claim in the OIDC token matches the value of the var.github_repository variable, which is explicitly passed in the tfvars file. This adds an extra layer of security by ensuring that only workflows from a specific GitHub repository can access the Google Cloud resources.

Step 3: Create a Google Cloud Service Account

   ```sh
   gcloud iam service-accounts create ghactions-sa \
       --display-name="GitHub Actions Service Account"
   ```

Step 4: Grant Necessary Roles to the Service Account

   ```sh
   gcloud projects add-iam-policy-binding gh-actions-1506 \
       --member="serviceAccount:ghactions-sa@gh-actions-1506.iam.gserviceaccount.com" \
       --role="roles/iam.serviceAccountTokenCreator"

  gcloud projects add-iam-policy-binding gh-actions-1506 \
       --member="serviceAccount:ghactions-sa@gh-actions-1506.iam.gserviceaccount.com" \
       --role="roles/iam.serviceAccountUser"

# Assign the roles/storage.objectAdmin role to the service account for the terraform state bucket 
  gsutil iam ch serviceAccount:ghactions-sa@gh-actions-1506.iam.gserviceaccount.com:objectAdmin gs://gh-actions-1506-tfstate

```

Step 5: Create an IAM binding for the above service account:
A binding assigns a specific IAM role to a list of members (principals) for the service account. In simple words we are actually granting permission to GitHub actions (coming from a specific GitHub repository) to use a Google Cloud service account.
This permission allows GitHub actions to act as the Google Cloud service account(service account impersonation) which is done by assigning the **iam.workloadIdentityUser** role, using Workload Identity Federation. This lets GitHub work with Google Cloud securely without needing to handle sensitive keys directly.

```sh
gcloud iam service-accounts add-iam-policy-binding "<ghactions-sa@gh-actions-1506.iam.gserviceaccount.com>" \
    --role="roles/iam.workloadIdentityUser" \
    --member="principalSet://iam.googleapis.com/projects/180855126385/locations/global/workloadIdentityPools/gh-actions-pool/attribute.repository/sam-nash/gh-actions"
```

A **principal** represents an identity(can be an user/service account/group etc) that can be granted roles to access Google Cloud resources like VM/GKE, Storage etc.

For requests originating from outside GCP there must be a way to use their identity to impersonate a service account. A regular principal is the most basic way to identify an incoming request to Workload Identity Federation that essentially uses just the subject.
This is the default subject for an OIDC token issued in GitHub Actions.

example: `principal://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/GCP_PROJECT_ID/subject/repo:${REPO}:ref:refs/heads/main`

A **PrincipalSet** on the other hand involves a group of principals based on specific attributes or conditions. This becomes useful when there are multiple principals that share common characteristics.

for example a principalSet can be configured to include all identities from a particular GitHub organization using a workload identity pool in the format `principalSet://iam.googleapis.com/projects/${var.project_name}/locations/global/workloadIdentityPools/${var.provider_name}/attribute.repository_owner/${var.repository_owner}`

Principals are used when you want to grant permissions to specific, individual identities. This approach ensures tight control over access, as each identity must be explicitly defined.
