terraform {
  backend "gcs" {
    bucket = "${var.project_name}-tfstate"
    prefix = "terraform/state"
  }
}
