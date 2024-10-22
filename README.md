# Learnings

A simple repo to capture my experiments with GCP as I learn along.

## GH Actions Terraform 

This is meant to provision resourcves on GCP using terraform. The repository iworkflows do not directly plan/apply resources on GCP but will make use of another repository that has been set up to perform these operations on GCP.

The workflow `.github/workflows/tf_dispatch.yml`is designed to trigger another workflow in a different repository that will authenticate to GCP using Workload Identity Federation rand perform Terraform pla/apply.

The workflow is configured to run on two types of events: push and pull_request. Both events are restricted to the master branch, meaning the workflow will only be triggered when there is a push or a pull request to the master branch.

The workflow consists of a single job named trigger, with a single step that uses the curl command to send a POST request to the GitHub API.

The curl command sends a POST request to the GitHub API endpoint for repository dispatch events. The request includes Authorization token which is a personal access token named `GH_DISPATCH_PAT` which is stored in the GitHub secrets. 

The body of the POST request (-d) contains a JSON payload with two fields: event_type and client_payload. The event_type is set to "terraform_apply", which is a custom event type that can be used to trigger specific workflows in the target repository. The client_payload includes additional data, in this case, the repository name, which is dynamically populated using the ${{ github.repository }} expression.
