variable "project_name" {
  type    = string
  default = "cloud-desk"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "azure_location" {
  description = "Azure region for the resource group"
  type        = string
  default     = "Central India"
}

variable "static_web_app_name" {
  description = "Globally unique name for the Static Web App"
  type        = string
}