variable "project_name" {
  type    = string
  default = "cloud-desk"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
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

variable "aws_monthly_budget_amount" {
  description = "Monthly AWS cost budget in USD"
  type        = number
  default     = 50
}

variable "gcp_project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud region for analytics resources"
  default     = "us-central1"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID containing the ECS task role"
}

variable "aws_task_role_name" {
  type        = string
  description = "Exact IAM role name assigned to the ECS API task"
}