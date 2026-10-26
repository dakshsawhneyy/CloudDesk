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

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "image_tag" {
  description = "Immutable ECR image tag to deploy"
  type        = string
  default     = "dev"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "alert_email" {
  description = "Email address for monitoring alerts"
  type        = string
  default     = ""
}