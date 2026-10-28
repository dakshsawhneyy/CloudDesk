resource "google_project_service" "services" {
  for_each = toset([
    "pubsub.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "sts.googleapis.com"
  ])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_pubsub_topic" "application_events" {
  project = var.project_id
  name    = "saas-application-events"

  depends_on = [google_project_service.services]
}

resource "google_bigquery_dataset" "analytics" {
  project    = var.project_id
  dataset_id = "saas_analytics"
  location   = var.region

  depends_on = [google_project_service.services]
}

resource "google_bigquery_table" "application_events" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  table_id   = "application_events"

  schema = jsonencode([
    { name = "event_id",   type = "STRING",    mode = "REQUIRED" },
    { name = "event_type", type = "STRING",    mode = "REQUIRED" },
    { name = "occurred_at", type = "TIMESTAMP", mode = "REQUIRED" },
    { name = "task_id",    type = "STRING",    mode = "NULLABLE" },
    { name = "environment", type = "STRING",   mode = "NULLABLE" }
  ])
}

resource "google_project_service_identity" "pubsub" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"

  depends_on = [google_project_service.services]
}

resource "google_bigquery_dataset_iam_member" "pubsub_writer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_project_service_identity.pubsub.email}"
}

resource "google_pubsub_subscription" "bigquery" {
  project = var.project_id
  name    = "saas-events-to-bigquery"
  topic   = google_pubsub_topic.application_events.id

  bigquery_config {
    table            = "${var.project_id}.${google_bigquery_dataset.analytics.dataset_id}.${google_bigquery_table.application_events.table_id}"
    use_table_schema = true
  }

  depends_on = [
    google_bigquery_dataset_iam_member.pubsub_writer
  ]
}

# Allow the AWS ECS task role to federate into Google Cloud.
resource "google_iam_workload_identity_pool" "aws_ecs" {
  project                   = var.project_id
  workload_identity_pool_id = "aws-ecs-pool"
  display_name              = "AWS ECS workload pool"

  depends_on = [google_project_service.services]
}

resource "google_iam_workload_identity_pool_provider" "aws_ecs" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.aws_ecs.workload_identity_pool_id
  workload_identity_pool_provider_id = "aws-ecs-provider"
  display_name                       = "AWS ECS task role"

  attribute_mapping = {
    "google.subject"       = "assertion.arn"
    "attribute.aws_role"   = "assertion.arn.extract('assumed-role/{role}/')"
  }

  attribute_condition = "attribute.aws_role == '${var.aws_task_role_name}'"

  aws {
    account_id = var.aws_account_id
  }
}

resource "google_service_account" "event_publisher" {
  project      = var.project_id
  account_id   = "ecs-event-publisher"
  display_name = "ECS application event publisher"

  depends_on = [google_project_service.services]
}

resource "google_pubsub_topic_iam_member" "publisher" {
  project = var.project_id
  topic   = google_pubsub_topic.application_events.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.event_publisher.email}"
}

data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account_iam_member" "aws_task_federation" {
  service_account_id = google_service_account.event_publisher.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.aws_ecs.workload_identity_pool_id}/attribute.aws_role/${var.aws_task_role_name}"

  depends_on = [
    google_iam_workload_identity_pool_provider.aws_ecs
  ]
}