# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a GCS bucket for Terraform state
resource "google_storage_bucket" "terraform_state" {
  name     = "${var.project_id}-terraform-state"
  location = var.region
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

# Enable necessary Google Cloud APIs
resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "iamcredentials" {
  service = "iamcredentials.googleapis.com"
}

resource "google_project_service" "sts" {
  service = "sts.googleapis.com"
}

# Create a Service Account
resource "google_service_account" "sa" {
  account_id   =  var.service_account_id
  display_name = var.service_account_display_name
}

# Grant the Workload Identity User role to the service account only if the variable pool_id is not empty

resource "google_project_iam_member" "workload_identity_user" {
  count   = var.pool_id != "" ? 1 : 0
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

# Create a Workload Identity Pool only if the variable pool_id is not empty
resource "google_iam_workload_identity_pool" "pool" {
  count                     = var.pool_id != "" ? 1 : 0
  provider                  = google
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_display_name
}

# Create a Workload Identity Provider within the pool only if the variable pool_id is not empty
resource "google_iam_workload_identity_pool_provider" "provider" {
  count                              = var.pool_id != "" ? 1 : 0
  provider                           = google
  workload_identity_pool_id          = google_iam_workload_identity_pool.pool[count.index].workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_id
  display_name                       = var.provider_display_name
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.aud"         = "assertion.aud"
  }
  attribute_condition = "attribute.org == \"${var.github_org}\""
}

# Grant the Workload Identity User role to the service account
resource "google_service_account_iam_binding" "binding" {
  count = var.pool_id != "" ? 1 : 0
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.pool[count.index].workload_identity_pool_id}/attribute.org/${var.github_org}"
  ]
}

# Create a normal compute Instance
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

# resource "google_compute_instance" "github_runner" {
#   name         = "github-runner"
#   machine_type = "e2-medium"
#   zone         = var.zone

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network = "default"

#     access_config {
#       // Ephemeral IP
#     }
#   }

#   metadata_startup_script = <<-EOF
#     #!/bin/bash
#     set -e

#     # Update and install dependencies
#     apt-get update
#     apt-get install -y curl jq

#     # Download the GitHub Actions runner
#     curl -o actions-runner-linux-x64.tar.gz -L "https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz"
#     tar xzf actions-runner-linux-x64.tar.gz

#     # Configure the runner
#     ./config.sh --url https://github.com/sam-nash/gh-actions --token ${var.github_runner_token} --unattended --replace

#     # Install and start the runner service
#     ./run.sh
#   EOF

#   tags = ["github-runner"]
# }

# output "instance_name" {
#   value = google_compute_instance.github_runner.name
# }