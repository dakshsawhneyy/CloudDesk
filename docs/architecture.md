# Architecture Overview

## Components

### Frontend
React application hosted on Azure.

### Backend
Node.js and Express API running on AWS ECS Fargate.

### Database
Amazon RDS for PostgreSQL.

### Analytics
Google Cloud Pub/Sub receives selected application events.
BigQuery stores data for analytics and reporting.

### CI/CD
GitHub Actions runs tests, builds artifacts,
performs security checks, and deploys approved changes.

### Infrastructure
Terraform manages supported cloud resources.

## Main Request Flow

User
-> React frontend
-> AWS Application Load Balancer
-> Node.js API
-> PostgreSQL database

## Analytics Flow

Node.js API
-> Application event
-> Google Cloud Pub/Sub
-> BigQuery

## Security Principles

- Least-privilege access
- Protected credentials
- HTTPS for application communication
- Auditable infrastructure changes
- Controlled deployment permissions

## Current Status

Architecture documented.
Infrastructure and application components
will be implemented in subsequent phases.