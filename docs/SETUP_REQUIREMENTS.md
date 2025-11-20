# Setup Requirements (Terraform Cloud backend)

This starter now uses Terraform Cloud (TFC) for remote state so GitHub Actions can plan/apply/destroy reliably without managing Azure Storage manually. Complete these one-time steps per customer/org.

## 1. Create / choose a Terraform Cloud organization
- Sign in at [https://app.terraform.io](https://app.terraform.io)
- Create an organization (e.g., `jtengineering`) if you don’t have one yet

## 2. Create a project (optional but recommended)
In Terraform Cloud, projects are just folders for workspaces. Create one like `Azure Infra Starter` (or reuse the default project). This keeps all of the customer’s workspaces grouped together.

## 3. Create workspaces for each environment
You can either:
- Create a workspace per environment (e.g., `azure-infra-cicd-dev`, `azure-infra-cicd-prod`), or
- Let Terraform manage them via a prefix.

When creating each workspace:
1. Choose the project you just created (or leave it as “Default Project” if you skipped that step).
2. Set the **Workflow type** to **CLI-driven workflow**. We trigger Terraform from GitHub Actions, so the workspace should *not* be connected to a VCS repo.

This repo’s backend config expects the prefix `azure-infra-cicd-`. With that prefix, running `terraform workspace select dev` maps to the remote workspace `azure-infra-cicd-dev`. Create those workspaces once in the TFC UI before running GitHub Actions.

## 4. Generate a Terraform Cloud user/API token
1. In the upper-right menu → **User Settings** → **Tokens**
2. Create a new token (name it something like `github-actions`)
3. Copy the token and add it to your GitHub repo secrets as `TF_API_TOKEN`

> Every workflow already exports `TF_API_TOKEN` for the orchestrator. No other secrets are needed for state access.

## 5. Create `terraform/backend.config`
Copy the example file and set your organization/prefix (or workspace names if you prefer exact names):

```bash
cp terraform/backend.config.example terraform/backend.config
```

Example contents:

```hcl
hostname     = "app.terraform.io"
organization = "jtengineering"

workspaces = {
  prefix = "azure-infra-cicd-"
}
```

If you want to pin explicit workspace names instead of prefixes, replace the block with:

```hcl
workspaces = {
  name = "azure-infra-cicd-dev"
}
```

(Then duplicate the backend config per environment.)

## 6. Local `terraform login` (optional)
If you plan to run Terraform locally, execute `terraform login` once so the CLI stores the token under `~/.terraform.d/credentials.tfrc.json`. GitHub Actions does not need this because it uses the `TF_API_TOKEN` secret directly.

## 7. Run the workflows
With the backend config file present and `TF_API_TOKEN` set, any workflow that references the orchestrator will initialize the remote backend automatically. Apply/destroy will share state across runs without any Azure Storage prerequisites.
