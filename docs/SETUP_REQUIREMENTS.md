# Setup Requirements (Azure Storage Backend)

Run through this page once per subscription to give Terraform a remote home for its state. After that, the GitHub workflows can plan/apply/destroy without any extra clicks.

## 1. Define your naming variables
These shell variables just make the copy/paste commands easier. Set them to whatever fits your environment (storage account names must be globally unique, lowercase, 3–24 chars). They are **not** GitHub secrets—just local values for the next CLI steps.

```bash
TFSTATE_LOCATION="eastus"
TFSTATE_RG="jteng-tfstate-rg"
TFSTATE_SA="jtengtfstate01"
TFSTATE_CONTAINER="tfstate"
SUBSCRIPTION_ID="<YOUR_SUBSCRIPTION_ID>"

# service principal object id (from README quickstart Step 1)
AZURE_CLIENT_ID="<YOUR_SP_CLIENT_ID>"
SP_OBJECT_ID=$(az ad sp show --id "$AZURE_CLIENT_ID" --query id -o tsv)

> Already have a storage account + container you want to reuse? Set these variables to those existing names (or create GitHub repo Variables with the same values). The workflows run `scripts/bootstrap-tfstate.sh`, which will simply detect they exist and move on, but the instructions below show what the script does under the hood.
```

## 2. Create the resource group + storage account + container

```bash
az group create --name "$TFSTATE_RG" --location "$TFSTATE_LOCATION"

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

## 3. Grant the GitHub Action Service Principal access

```bash
az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id "$SP_OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$TFSTATE_RG/providers/Microsoft.Storage/storageAccounts/$TFSTATE_SA"
```

Now every `azure/login@v2` run can read/write Terraform state—no SAS keys or extra secrets required.

## 4. Copy the backend config

```bash
cp terraform/backend.config.example terraform/backend.config
```

Edit `terraform/backend.config` if you chose different names or want a different key (e.g., prod). The default key is `azure-infra-cicd-starter.tfstate`; Terraform automatically scopes non-default workspaces under `env:<workspace>/`, so you only need one file for dev/prod.

## 5. Run Terraform

From here on out, you just run:

```bash
cd terraform
terraform init -backend-config=backend.config
terraform workspace select dev   # or workspace new dev
terraform plan -var-file=environments/dev.tfvars
```

The GitHub workflows pass the same backend config and Terraform workspaces, so plan/apply/destroy work exactly the same on CI.

### Optional: configure GitHub repo variables
If you want each workflow run to double-check (or create) the backend automatically, go to **Settings → Variables** and add:

- `TFSTATE_RG`
- `TFSTATE_LOCATION`
- `TFSTATE_SA`
- `TFSTATE_CONTAINER`

Set them to the same values you used above. The `scripts/bootstrap-tfstate.sh` step executed in every workflow will use those values; if the resources already exist it does nothing, otherwise it creates them idempotently before Terraform runs.
