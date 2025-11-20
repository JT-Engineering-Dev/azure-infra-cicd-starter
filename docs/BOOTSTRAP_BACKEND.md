# Bootstrap Remote Terraform State (Azure Storage Backend)

The starter uses the `azurerm` backend so every GitHub Actions run can read/write the same Terraform state. Complete these one-time steps per subscription / environment.

## 1. Decide your naming

| Item | Example | Notes |
| --- | --- | --- |
| Resource group | `jteng-tfstate-rg` | Any region; only stores state |
| Storage account | `jtengtfstate01` | Must be globally unique, 3-24 lowercase letters/numbers |
| Container | `tfstate` | Standard blob container |
| State key | `azure-infra-cicd-starter/dev.tfstate` | One key per workspace/environment |

## 2. Create the resources

```bash
# Variables to reuse
TFSTATE_RG="jteng-tfstate-rg"
TFSTATE_LOCATION="eastus"
TFSTATE_SA="jtengtfstate01"
TFSTATE_CONTAINER="tfstate"

az group create \
  --name "$TFSTATE_RG" \
  --location "$TFSTATE_LOCATION"

az storage account create \
  --name "$TFSTATE_SA" \
  --resource-group "$TFSTATE_RG" \
  --location "$TFSTATE_LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false

az storage container create \
  --name "$TFSTATE_CONTAINER" \
  --account-name "$TFSTATE_SA"
```

## 3. Grant access to the Service Principal / Federated Credential

The identity used by GitHub Actions must be able to read/write blobs. Assign **Storage Blob Data Contributor** on the storage account:

```bash
AZURE_SP_OBJECT_ID="<service-principal-object-id>"

az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id "$AZURE_SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --scope "/subscriptions/<SUB_ID>/resourceGroups/$TFSTATE_RG/providers/Microsoft.Storage/storageAccounts/$TFSTATE_SA"
```

## 4. Create `terraform/backend.config`

Copy the example file and adjust the values:

```bash
cp terraform/backend.config.example terraform/backend.config
```

Edit `terraform/backend.config` with your names and preferred state key:

```hcl
resource_group_name  = "jteng-tfstate-rg"
storage_account_name = "jtengtfstate01"
container_name       = "tfstate"
key                  = "azure-infra-cicd-starter/dev.tfstate"
use_azuread_auth     = true
```

`use_azuread_auth = true` tells Terraform to reuse the same Azure AD token issued via `azure/login@v2`, so no storage keys are required.

## 5. Reference the backend config in GitHub Actions

The repo workflows already pass `backend-config-file: backend.config` to the orchestrator action. As soon as the file exists in `terraform/`, every run will use remote state automatically.

If you prefer a different path or multiple backends per environment, update the workflow input accordingly.

### ARM_* environment variables

The workflows export `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, and `ARM_SUBSCRIPTION_ID` from your GitHub secrets before calling Terraform. If you rename secrets or use different credential names, update the workflow environment so the backend can authenticate using the same Service Principal.
