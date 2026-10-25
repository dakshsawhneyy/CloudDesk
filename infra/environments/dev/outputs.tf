output "project_name" {
  description = "SaaS project name"
  value       = terraform_data.project_foundation.output.project_name
}

output "environment" {
  description = "Configured environment"
  value       = terraform_data.project_foundation.output.environment
}