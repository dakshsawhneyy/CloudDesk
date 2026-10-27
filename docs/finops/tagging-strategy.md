# Multi-Cloud Tagging Strategy

## Required resource metadata

| Key | Example | Purpose |
|---|---|---|
| Project | enterprise-saas | Project attribution |
| Environment | dev | Environment cost breakdown |
| Service | api | Service ownership |
| ManagedBy | terraform | Lifecycle ownership |
| Owner | platform-team | Responsible team |

## Rules

1. Use consistent keys and values across environments.
2. Apply tags or labels to every supported resource.
3. Do not place credentials, personal data, or secrets in tags.
4. Review untagged resources monthly.
5. Treat shared infrastructure costs using a documented allocation rule.
6. Keep billing account and project identifiers out of public repositories
   when they are not needed for the documented example.

## Cloud-specific implementation

- AWS: resource tags and activated cost allocation tags.
- Azure: resource tags and Azure Cost Management.
- GCP: resource labels where supported and Cloud Billing reports.