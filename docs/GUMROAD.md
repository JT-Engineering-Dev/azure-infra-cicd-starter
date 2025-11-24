# Gumroad Product Copy – Azure Infra + CI/CD Starter

## Product Title
Azure Infra + CI/CD Starter (Terraform + GitHub Actions)

## Short Description
Launch a production-ready Azure landing zone in under an hour. Includes modular Terraform, GitHub Actions automation, Azure Storage backend bootstrap, and deep-dive docs so junior/mid engineers can deploy with confidence.

## Long Description / Sections
### Who It’s For
- Platform / DevOps engineers standing up new Azure environments
- Consultants delivering Azure foundations to multiple clients
- Small teams who want Terraform + CI/CD best practices without weeks of trial-and-error

### What You Get
- Full Terraform project (network, observability, container artifacts, tfvars for dev/prod)
- GitHub Actions workflows wired to the shared Terraform Orchestrator Marketplace Action
- Azure Storage backend configuration + optional auto-bootstrap script (`scripts/bootstrap-tfstate.sh`)
- 20+ page implementation guide (PDF/Markdown) covering secrets, repo variables, troubleshooting, upgrade paths, and monetization ideas
- Architecture diagram + checklist
- Lifetime updates + email support (support@jtengineering.dev)

### How It Works
1. Create a Service Principal (CLI snippet provided).
2. Copy `backend.config.example`, set your Azure Storage names (or let the repo variables + bootstrap script create them automatically).
3. Push to GitHub → run the included workflows → Terraform provisions RG/VNet/Subnets + ACR + Container Apps Environment + Log Analytics.
4. Rerun workflows whenever you tweak `environments/dev.tfvars` or `prod.tfvars`.

### Requirements
- Azure subscription with Contributor permissions
- GitHub repository (public or private)
- Ability to store 4 repo secrets (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`)

### Bonuses (optional upsells)
- Private Loom walkthrough (add-on)
- Access to future AWS/GCP starter kits at discounted bundle pricing

## Pricing Ideas
- Launch: $99 USD
- Future bundles (Azure + AWS + GCP): $249 USD
- Add-on support/consulting blocks (2 hours) for $250 USD

## Gumroad Assets Needed
- Cover image (architecture diagram or hero graphic)
- 2–3 screenshots (README quickstart, workflows, architecture diagram)
- Download bundle (.zip) containing:
  - `README_PRO_GUIDE.pdf`
  - `SETUP_CHECKLIST.md`
  - `UPGRADE_PATHS.md` (optional)

## Call To Action
“Skip the Terraform yak-shave. Clone the repo, run the workflows, and ship a clean Azure foundation today.”
