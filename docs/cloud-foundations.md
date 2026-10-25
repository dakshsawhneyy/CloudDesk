# Multi-Cloud Foundations and Identity

## 1. Project Information

Project: Enterprise-Grade Multi-Cloud SaaS
Environment: Development
Repository: enterprise-multicloud-saas

## 2. Cloud Provider Responsibilities

### AWS
Purpose:
- Host the Node.js API on ECS Fargate
- Provide PostgreSQL through RDS
- Expose the API through an Application Load Balancer

Account ID: <PENDING>
Authentication: Approved role-based sign-in
Provisioning: Terraform

### Azure
Purpose:
- Host the React frontend

Subscription ID: <PENDING>
Authentication: Microsoft Entra ID
Provisioning: Terraform

### Google Cloud
Purpose:
- Publish application events through Pub/Sub
- Store analytics in BigQuery

Project ID: <PENDING>
Authentication: Google Cloud IAM
Provisioning: Terraform

## 3. Automation Identity Strategy

CI/CD platform: GitHub Actions
Infrastructure as Code: Terraform

Preferred authentication:
- AWS: GitHub OIDC to an IAM role
- Azure: Microsoft Entra workload identity federation
- GCP: Workload Identity Federation

Long-lived cloud credentials in GitHub repository secrets:
- Not intended

## 4. Least-Privilege Requirements

- Separate infrastructure provisioning and application runtime access.
- Restrict automation to approved repositories and workflows.
- Restrict permissions to required resources and operations.
- Avoid unrestricted administrator permissions.
- Protect production deployments with appropriate approval controls.
- Never commit secrets, private keys, or local environment files.

## 5. Current Status

- [ ] Cloud accounts and project access verified
- [ ] CLI authentication verified
- [ ] Target subscription and project selected
- [ ] AWS GitHub OIDC trust configured
- [ ] Azure workload identity federation configured
- [ ] GCP Workload Identity Federation configured
- [ ] Terraform permissions reviewed

Note: Federation configuration and cloud provisioning are
planned for subsequent phases.