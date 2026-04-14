# Getting Started

This guide covers the supported setup path for both GitHub Codespaces and WSL.

## Required Inputs

Provide these through platform-managed secrets and variables such as GitHub Codespaces secrets and variables, GitHub Actions secrets and variables, or Azure Pipelines variables and secrets:

- `GH_TOKEN`
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

Default repo values:

- `APP_SHORT_NAME=this-ninja.github.io`

If the `boards` module is enabled, also provide:

- `AZURE_DEVOPS_EXT_PAT`
- `AZURE_DEVOPS_ORG`
- `AZURE_DEVOPS_PROJECT`
