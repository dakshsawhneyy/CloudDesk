# Monitoring and Incident Response Runbook

## 1. API latency or errors

1. Check the CloudWatch dashboard for ALB target response time and 5xx errors.
2. Check ECS CPU, memory, running task count, and service events.
3. Search the API CloudWatch log group for errors during the incident window.
4. Correlate request IDs and timestamps.
5. Check RDS CPU, connections, and availability if database errors appear.
6. Record the suspected cause, evidence, mitigation, and follow-up action.

## 2. ECS task failures

1. Inspect ECS service events.
2. Review stopped-task reasons and container exit codes.
3. Check CloudWatch application logs.
4. Verify image availability, task execution role permissions,
   environment variables, and secret retrieval.
5. Roll back to a known-good release if the new deployment is responsible.

## 3. Analytics delivery delay

1. Check GCP Pub/Sub topic publishing errors.
2. Inspect subscription backlog and oldest unacknowledged message age.
3. Check BigQuery subscription delivery errors.
4. Verify BigQuery schema compatibility and service-agent permissions.
5. Determine whether the delay affects analytics only or also affects
   the application's primary task operation.

## 4. Incident record

- Incident start and end:
- Impact:
- Alert and dashboard:
- Relevant request IDs:
- Root cause and evidence:
- Mitigation:
- Recovery verification:
- Preventive actions: