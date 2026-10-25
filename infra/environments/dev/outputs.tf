output "project_name" {
  description = "SaaS project name"
  value       = terraform_data.project_foundation.output.project_name
}

output "environment" {
  description = "Configured environment"
  value       = terraform_data.project_foundation.output.environment
}

output "frontend_url" {
  value = module.azure_frontend.frontend_url
}

output "resource_group_name" {
  value = module.azure_frontend.resource_group_name
}