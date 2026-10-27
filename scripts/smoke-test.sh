#!/usr/bin/env bash
set -Eeuo pipefail

BASE_URL="${BASE_URL:-http://localhost:3000}"
TASK_TITLE="Reliability smoke test $(date -u +%Y%m%dT%H%M%SZ)"

echo "Checking API liveness..."
curl --fail --silent --show-error \
  "$BASE_URL/health" | jq .

echo "Checking database readiness..."
curl --fail --silent --show-error \
  "$BASE_URL/ready" | jq .

echo "Creating a test task..."
CREATE_RESPONSE=$(
  curl --fail --silent --show-error \
    --request POST \
    --header "Content-Type: application/json" \
    --data "$(jq -n --arg title "$TASK_TITLE" '{title: $title}')" \
    "$BASE_URL/api/tasks"
)

echo "$CREATE_RESPONSE" | jq .

echo "Checking task persistence..."
TASKS_RESPONSE=$(
  curl --fail --silent --show-error \
    "$BASE_URL/api/tasks"
)

echo "$TASKS_RESPONSE" | jq .

echo "$TASKS_RESPONSE" | jq -e \
  --arg title "$TASK_TITLE" \
  'any(.[]; .title == $title)' >/dev/null

echo "PASS: API, database readiness, task creation, and task retrieval."