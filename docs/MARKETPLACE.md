# Azure Infrastructure + CI/CD Starter (Terraform + GitHub Actions)

A minimal, production-grade Azure environment deployed via Terraform with GitHub Actions automation. Ideal for DevOps teams, platform engineers, and solo builders.

## Features
- Remote Azure Storage backend (state shared across runs)
- Modular Terraform (network, observability, container artifacts)
- Prebuilt GitHub Actions (plan, plan+apply, destroy) that call this orchestrator action
- One-click tfstate bootstrap via `scripts/bootstrap-tfstate.sh` (optional repo variables)
- Service principal or OIDC authentication
- Example dev/prod tfvars + architecture diagram included

## What's Included
- Terraform modules & sample tfvars
- CI/CD workflows that call this action
- README + Setup requirements (Azure CLI snippets, repo variable guidance)
- MIT License

## Audience
- Platform engineers
- DevOps engineers
- Startups & consultants
- Anyone bootstrapping Azure

## Support
support@jtengineering.dev
