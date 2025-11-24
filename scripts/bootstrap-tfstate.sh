#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${TFSTATE_RG:-}" || -z "${TFSTATE_LOCATION:-}" || -z "${TFSTATE_SA:-}" || -z "${TFSTATE_CONTAINER:-}" ]]; then
  echo "[tfstate] Skipping bootstrap (TFSTATE_* variables not set)."
  exit 0
fi

az group show --name "$TFSTATE_RG" >/dev/null 2>&1 || \
az group create --name "$TFSTATE_RG" --location "$TFSTATE_LOCATION" --only-show-errors >/dev/null

az storage account show --name "$TFSTATE_SA" --resource-group "$TFSTATE_RG" >/dev/null 2>&1 || \
az storage account create \
  --name "$TFSTATE_SA" \
  --resource-group "$TFSTATE_RG" \
  --location "$TFSTATE_LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --allow-blob-public-access false \
  --only-show-errors >/dev/null

az storage container create \
  --name "$TFSTATE_CONTAINER" \
  --account-name "$TFSTATE_SA" \
  --auth-mode login \
  --only-show-errors >/dev/null

declare SP_OBJECT_ID
SP_OBJECT_ID=""
SUB_ID="${ARM_SUBSCRIPTION_ID:-${AZURE_SUBSCRIPTION_ID:-${SUBSCRIPTION_ID:-}}}"
if [[ -z "$SUB_ID" ]]; then
  echo "[tfstate] WARN: subscription id not provided; skipping role assignment."
fi
if [[ -n "${AZURE_CLIENT_ID:-}" ]]; then
  SP_OBJECT_ID=$(az ad sp show --id "$AZURE_CLIENT_ID" --query id -o tsv 2>/dev/null || true)
fi

if [[ -n "$SP_OBJECT_ID" && -n "$SUB_ID" ]]; then
  SCOPE="/subscriptions/$SUB_ID/resourceGroups/$TFSTATE_RG/providers/Microsoft.Storage/storageAccounts/$TFSTATE_SA"
  if ! az role assignment list --assignee "$SP_OBJECT_ID" --scope "$SCOPE" --query "[?roleDefinitionName=='Storage Blob Data Contributor']" -o tsv | grep -q "Storage Blob Data Contributor"; then
    az role assignment create \
      --role "Storage Blob Data Contributor" \
      --assignee-object-id "$SP_OBJECT_ID" \
      --assignee-principal-type ServicePrincipal \
      --scope "$SCOPE" \
      --only-show-errors >/dev/null || true
  fi
else
  echo "[tfstate] WARN: Could not determine service principal object id; please ensure blob role exists." >&2
fi

echo "[tfstate] Backend resources ready (rg=$TFSTATE_RG sa=$TFSTATE_SA container=$TFSTATE_CONTAINER)."
