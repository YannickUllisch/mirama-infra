// Secrets temporary 
variable "COGNITO_USER_POOL_ID" {
  type      = string
  sensitive = true
}

variable "COGNITO_ISSUER" {
  type      = string
  sensitive = true
}

variable "COGNITO_CLIENT_ID" {
  type      = string
  sensitive = true
}

variable "COGNITO_DOMAIN_URL" {
  type      = string
  sensitive = true
}

variable "NOTIFICATION_TOPIC_ARN" {
  type      = string
  sensitive = true
}

variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "RESEND_API_KEY" {
  type      = string
  sensitive = true
}

variable "NEXTAUTH_SECRET" {
  type      = string
  sensitive = true
}

variable "REDIS_URL" {
  type      = string
  sensitive = true
}

variable "POSTGRES_URL_NON_POOLING" {
  type      = string
  sensitive = true
}

variable "POSTGRES_PRISMA_URL" {
  type      = string
  sensitive = true
}