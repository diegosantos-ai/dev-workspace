variable "ovh_endpoint" {
  type        = string
  description = "Endpoint da OVHcloud, ex: ovh-eu"
}

variable "ovh_application_key" {
  type        = string
  description = "Application Key da API OVHcloud"
  sensitive   = true
}

variable "ovh_application_secret" {
  type        = string
  description = "Application Secret da API OVHcloud"
  sensitive   = true
}

variable "ovh_consumer_key" {
  type        = string
  description = "Consumer Key da API OVHcloud"
  sensitive   = true
}
