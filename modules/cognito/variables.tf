variable "environment" {
  description = "The environment for the user pool (e.g. prod or dev)"
  type        = string
}

variable "domain_url" {
  description = "The domain that the Mirama Service runs on in the production environment"
  type        = string
}

variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
}