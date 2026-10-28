output "project_id" {
  value = var.project_id
}

output "topic_name" {
  value = google_pubsub_topic.application_events.name
}

output "service_account_email" {
  value = google_service_account.event_publisher.email
}

output "workload_identity_provider_name" {
  value = google_iam_workload_identity_pool_provider.aws_ecs.name
}

output "dataset_id" {
  value = google_bigquery_dataset.analytics.dataset_id
}

output "table_id" {
  value = google_bigquery_table.application_events.table_id
}