terraform {
  backend "gcs" {
    bucket = "gh-actions-1506-tfstate"
    prefix = "terraform/state"
  }
}
