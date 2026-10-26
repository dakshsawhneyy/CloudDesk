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

output "aws_api_url" {
  description = "Public development API URL"
  value       = module.aws_backend.api_url
}

output "cloudwatch_dashboard_name" {
  value = aws_cloudwatch_dashboard.application.dashboard_name
}

output "sns_alert_topic_arn" {
  value = aws_sns_topic.alerts.arn
}