# Define the project ID variable
variable "project_id" {
  description = "The ID of the project"
  type        = string
}

# Define the region variable
variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"
}

# Define the zone variable
variable "zone" {
  description = "The zone of the project"
  type        = string
  default     = "us-central1-a"
}

# Define the workload identity pool ID variable
variable "pool_id" {
  description = "The ID of the workload identity pool"
  type        = string
}

# Define the workload identity pool display name variable
variable "pool_display_name" {
  description = "The display name of the workload identity pool"
  type        = string
}

# Define the workload identity provider ID variable
variable "provider_id" {
  description = "The ID of the workload identity pool provider"
  type        = string
}

# Define the workload identity provider display name variable
variable "provider_display_name" {
  description = "The display name of the workload identity pool provider"
  type        = string
}

# Define the service account ID variable
variable "service_account_id" {
  description = "The ID of the service account"
  type        = string
}

# Define the service account display name variable
variable "service_account_display_name" {
  description = "The display name of the service account"
  type        = string
}

# Define the project number variable
variable "project_number" {
  description = "The number of the project"
  type        = string
}

# Define the GitHub repository variable
variable "github_repository" {
  description = "The GitHub repository"
  type        = string
}

# define the GitHub repository owner variable
variable "github_repository_owner" {
  description = "The GitHub repository owner"
  type        = string
}

# Define the GitHub ORG variable
variable "github_org" {
  description = "The GitHub organization"
  type        = string
}

# Deine the GitHub runner token
variable "github_runner_token" {
  description = "The GitHub runner token"
  type        = string
}