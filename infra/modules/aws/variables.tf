variable "project_name" {
  type    = string
  default = "enterprise-multicloud-saas"
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    # Subjective - your organization
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "image_tag" {
  description = "Immutable tag of the image already pushed to ECR"
  type        = string
  default     = "dev"
}

variable "db_name" {
  type    = string
  default = "saasdb"
}

variable "db_username" {
  type    = string
  default = "saasadmin"
}

variable "frontend_origin" {
  type = string
}

variable "alert_email" {
  description = "Email address for development monitoring alerts; empty disables email subscription"
  type        = string
  default     = ""
}

variable "monthly_budget_amount" {
  description = "Monthly AWS cost budget in USD"
  type        = number
  default     = 50

  validation {
    condition     = var.monthly_budget_amount > 0
    error_message = "Monthly budget must be greater than zero."
  }
}

variable "aws_monthly_budget_amount" {
  description = "Monthly AWS cost budget in USD"
  type        = number
  default     = 50
}


############################
variable "gcp_project_id" {
  type = string
}

variable "gcp_pubsub_topic" {
  type = string
}