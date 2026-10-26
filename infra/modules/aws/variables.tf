variable "project_name" {
  type    = string
  default = "enterprise-multicloud-saas"
}

variable "environment" {
  type    = string
  default = "dev"
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