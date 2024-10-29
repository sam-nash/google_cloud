# Learnings

A simple repo to capture my experiments with GCP as I learn along.

## GH Actions Terraform 

This is meant to provision resourcves on GCP using terraform. The repository iworkflows do not directly plan/apply resources on GCP but will make use of another repository that has been set up to perform these operations on GCP.

The workflow `.github/workflows/tf_dispatch.yml`is designed to trigger another workflow in a different repository that will authenticate to GCP using Workload Identity Federation rand perform Terraform pla/apply.

The workflow is configured to run on two types of events: push and pull_request. Both events are restricted to the master branch, meaning the workflow will only be triggered when there is a push or a pull request to the master branch.

The workflow consists of a single job named trigger, with a single step that uses the curl command to send a POST request to the GitHub API.

The curl command sends a POST request to the GitHub API endpoint for repository dispatch events. The request includes Authorization token which is a personal access token named `GH_DISPATCH_PAT` which is stored in the GitHub secrets. 

The body of the POST request (-d) contains a JSON payload with two fields: event_type and client_payload. The event_type is set to "terraform_apply", which is a custom event type that can be used to trigger specific workflows in the target repository. So in our target repository we have a workflow that has the event called  repository_dispatch with types: [terraform_apply] that gets triggered when it receives this call. The client_payload includes additional data, in this case, the repository name, which is dynamically populated using the ${{ github.repository }} expression.

## Run Cloud Build on commit to Giuthub Repo

Step 1a - Enable Cloud Build API: Ensure that the Cloud Build API is enabled in your GCP project.

```gcloud services enable cloudbuild.googleapis.com```

Step 1b - Grant the storage object admin permissions to the service account

```sh
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \           
  --member="serviceAccount:ghactions-sa@gh-actions-1506.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
```

Step 1c - Create the logs bucket

```sh
gcloud storage buckets create gs://test_cloudbuild_logs --project=YOUR_PROJECT_ID
```

Step 1d - Give the service account explicit access tot he logs bucket

```sh
gsutil iam ch serviceAccount:ghactions-sa@gh-actions-1506.iam.gserviceaccount.com:objectAdmin gs://test_cloudbuild_logs
```

Step 2 - Connect Your GitHub Repository: Link your GitHub repository to Google Cloud Build.

Go to the Google Cloud Console.
Navigate to Cloud Build > Triggers.
Click on Connect Repository.
Select GitHub and follow the prompts to authorize and connect your GitHub account.
Select the repository you want to connect.

Step 3 - Create a Build Trigger: Create a trigger that runs your Cloud Build configuration whenever there is a commit to the repository.

In the Triggers section of Cloud Build, click on Create Trigger.
Configure the trigger with the following settings:
Name: Give your trigger a name.
Event: Select Push to a branch.
Source: Select the repository and branch you want to monitor.
Build Configuration: Choose Cloud Build configuration file (yaml or json).
Cloud Build configuration file location: Enter the path to your cloudbuild.yaml file (e.g., readCSV.yaml).
