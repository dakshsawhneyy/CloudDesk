output "ecr_repository_url" {
  value = aws_ecr_repository.api.repository_url
}

output "api_url" {
  value = "http://${aws_lb.api.dns_name}"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}

output "cloudwatch_dashboard_name" {
  value = aws_cloudwatch_dashboard.application.dashboard_name
}

output "sns_alert_topic_arn" {
  value = aws_sns_topic.alerts.arn
}