# Reliability and Disaster Recovery Runbook

## 1. Scope

Application components:
- Azure Static Web Apps: frontend
- AWS ALB and ECS Fargate: API
- AWS RDS PostgreSQL: task data
- GCP Pub/Sub and BigQuery: analytics

## 2. Initial triage

1. Check API health and readiness.
2. Review ALB target health and HTTP 5xx errors.
3. Inspect ECS task status, stopped-task reasons, and application logs.
4. Check RDS availability, connections, storage, and recent events.
5. Check Pub/Sub backlog and analytics delivery errors.
6. Identify the affected component before taking recovery action.

## 3. Failed application deployment

1. Review the GitHub Actions deployment result.
2. Inspect ECS service events and task logs.
3. Confirm whether the deployment circuit breaker rolled back.
4. If necessary, redeploy the last known-good task definition
   using the approved release procedure.
5. Run scripts/smoke-test.sh against the recovered API.
6. Confirm error rates and latency return to acceptable levels.

## 4. Database incident

1. Determine whether the issue is connectivity, capacity,
   database failure, or data corruption.
2. Avoid destructive changes before understanding the cause.
3. For a recoverable instance failure, follow the AWS RDS
   recovery procedure appropriate to the failure.
4. For data loss or corruption, select an appropriate recovery
   point and restore into a controlled instance.
5. Validate schema, records, API readiness, and task CRUD.
6. Record the recovery point and any data loss.

## 5. Recovery objectives

Proposed targets for planning, not yet measured:
- RTO: 60 minutes
- RPO: 15 minutes

Validate these targets through timed recovery exercises.
Do not claim they are achieved until tested.

## 6. Post-incident record

Record:
- Incident start and detection time
- Affected components and user impact
- Root cause and contributing factors
- Mitigation and recovery timeline
- Data loss, if any
- Preventive actions, owners, and due dates