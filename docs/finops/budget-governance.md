# Multi-Cloud Budget Governance

## AWS

- Monthly cost budget managed by Terraform.
- Alerts at 50%, 80%, and 100% of the configured budget.
- Review Cost Explorer for service-level cost changes.
- Review activated cost allocation tags.
- Review ECS, RDS, ALB, ECR, and CloudWatch usage monthly.

## Azure

- Configure a monthly budget in Azure Cost Management.
- Scope it to the subscription or resource group containing the frontend.
- Configure notifications at 50%, 80%, and 100%.
- Review the Static Web Apps plan and usage against actual requirements.

## Google Cloud

- Configure a billing budget for the analytics project.
- Configure alerts at 50%, 80%, and 100%.
- Review Pub/Sub message volume and BigQuery storage/query costs.
- Review billing reports for unexpected changes.

## Monthly review

1. Compare actual spending with the previous month.
2. Investigate unexpected changes and untagged resources.
3. Review resource utilization and unused resources.
4. Estimate cost per task or analytics event where useful.
5. Record optimization actions and their owners.

## Important

Budgets and notifications do not automatically stop resource spending.
Use separate operational controls for shutdowns, quotas, and access restrictions.