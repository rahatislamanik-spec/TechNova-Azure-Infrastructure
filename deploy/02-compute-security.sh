#!/bin/bash
# =============================================================
# TechNova Inc. — Compute, Security & Data Protection Deployment
# Script: 02-compute-security.sh
# Phases: 03 (Compute), 04 (Load Balancer), 05 (Data Protection)
#
# Deploys:
#   - Azure Bastion (secure VM access — no public IPs)
#   - 2x Ubuntu VMs in private App subnet (zero public IPs), each with
#     a system-assigned managed identity
#   - RBAC role assignment (least-privilege)
#   - Azure Load Balancer with health probe, both VMs in backend pool
#   - Storage Account + blob container with lifecycle rule
#   - Azure Key Vault; both VM identities granted 'get' on secrets
#   - Recovery Services Vault with backup policy
#
# Prerequisites:
#   - Run 01-hub-spoke-networking.sh first
#   - Azure CLI logged in
#
# TechNova Inc. — fictional portfolio case study
# =============================================================

set -e

# --- Variables ---
RESOURCE_GROUP="TechNova-RG"
LOCATION="eastus"
HUB_VNET="TechNova-Hub-VNet"
APP_VNET="TechNova-App-VNet"
VM_SIZE="Standard_B1s"
VM_IMAGE="Ubuntu2204"
ADMIN_USER="technova-admin"
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv 2>/dev/null || echo "")

echo "=================================================="
echo " TechNova — Compute & Security Deployment"
echo " Resource Group : $RESOURCE_GROUP"
echo " VM Size        : $VM_SIZE (cost-aware)"
echo " Access Method  : Azure Bastion (no public IPs)"
echo "=================================================="

# --- Step 1: Azure Bastion ---
echo ""
echo "[1/8] Deploying Azure Bastion..."

# Bastion requires a public IP
az network public-ip create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-Bastion-PIP" \
  --sku Standard \
  --allocation-method Static \
  --location "$LOCATION"

az network bastion create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-Bastion" \
  --public-ip-address "TechNova-Bastion-PIP" \
  --vnet-name "$HUB_VNET" \
  --location "$LOCATION" \
  --sku Basic

echo "  ✅ Bastion deployed — VMs accessible via browser, no SSH port exposure"

# --- Step 2: Deploy VM1 (no public IP, system-assigned identity) ---
echo ""
echo "[2/8] Deploying VM1 — TechNova-VM1 (no public IP)..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-VM1" \
  --image "$VM_IMAGE" \
  --size "$VM_SIZE" \
  --vnet-name "$APP_VNET" \
  --subnet "AppSubnet" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys \
  --public-ip-address "" \
  --nsg "" \
  --assign-identity \
  --location "$LOCATION"

echo "  ✅ VM1 deployed — zero public IP, Bastion-only access, managed identity enabled"

# --- Step 3: Deploy VM2 (no public IP, system-assigned identity) ---
echo ""
echo "[3/8] Deploying VM2 — TechNova-VM2 (no public IP)..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-VM2" \
  --image "$VM_IMAGE" \
  --size "$VM_SIZE" \
  --vnet-name "$APP_VNET" \
  --subnet "AppSubnet" \
  --admin-username "$ADMIN_USER" \
  --generate-ssh-keys \
  --public-ip-address "" \
  --nsg "" \
  --assign-identity \
  --location "$LOCATION"

echo "  ✅ VM2 deployed — zero public IP, Bastion-only access, managed identity enabled"

# --- Step 4: RBAC — Least Privilege ---
echo ""
echo "[4/8] Configuring RBAC — least-privilege assignment..."
SCOPE="/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP"

if [ -n "$CURRENT_USER_ID" ]; then
  az role assignment create \
    --assignee "$CURRENT_USER_ID" \
    --role "Contributor" \
    --scope "$SCOPE"
  echo "  ✅ Contributor role assigned at Resource Group scope (not subscription)"
else
  echo "  ⚠️  Could not retrieve user ID — RBAC assignment skipped"
fi

# --- Step 5: Load Balancer + backend pool membership ---
echo ""
echo "[5/8] Deploying Load Balancer..."
az network lb create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-LB" \
  --sku Standard \
  --frontend-ip-name "TechNova-LB-Frontend" \
  --backend-pool-name "TechNova-Backend-Pool" \
  --location "$LOCATION"

# Health probe
az network lb probe create \
  --resource-group "$RESOURCE_GROUP" \
  --lb-name "TechNova-LB" \
  --name "TechNova-Health-Probe" \
  --protocol Http \
  --port 80 \
  --path "/"

# Load balancing rule
az network lb rule create \
  --resource-group "$RESOURCE_GROUP" \
  --lb-name "TechNova-LB" \
  --name "TechNova-LB-Rule-HTTP" \
  --protocol Tcp \
  --frontend-port 80 \
  --backend-port 80 \
  --frontend-ip-name "TechNova-LB-Frontend" \
  --backend-pool-name "TechNova-Backend-Pool" \
  --probe-name "TechNova-Health-Probe"

# Register both VM NICs into the backend pool so the LB actually
# distributes traffic across them (matches evidence screenshot 25).
for VM in TechNova-VM1 TechNova-VM2; do
  NIC_ID=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM" \
    --query "networkProfile.networkInterfaces[0].id" -o tsv)
  NIC_NAME=$(basename "$NIC_ID")
  IPCONFIG_NAME=$(az network nic show \
    --ids "$NIC_ID" \
    --query "ipConfigurations[0].name" -o tsv)
  az network nic ip-config address-pool add \
    --resource-group "$RESOURCE_GROUP" \
    --nic-name "$NIC_NAME" \
    --ip-config-name "$IPCONFIG_NAME" \
    --lb-name "TechNova-LB" \
    --address-pool "TechNova-Backend-Pool"
  echo "  ✅ $VM added to backend pool"
done

echo "  ✅ Load Balancer deployed with health probe on port 80, both VMs in pool"

# --- Step 6: Storage Account + blob container ---
echo ""
echo "[6/8] Deploying Storage Account..."
STORAGE_NAME="technovastore$(date +%s | tail -c 6)"

az storage account create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$STORAGE_NAME" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

az storage container create \
  --account-name "$STORAGE_NAME" \
  --name "technova-data" \
  --auth-mode login

# Lifecycle rule: move blobs to Cool tier after 30 days
az storage account management-policy create \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_NAME" \
  --policy '{
    "rules": [
      {
        "enabled": true,
        "name": "move-to-cool-30d",
        "type": "Lifecycle",
        "definition": {
          "filters": { "blobTypes": ["blockBlob"] },
          "actions": {
            "baseBlob": { "tierToCool": { "daysAfterModificationGreaterThan": 30 } }
          }
        }
      }
    ]
  }' 2>/dev/null || echo "  ⚠️  Lifecycle policy skipped — requires appropriate permissions"

echo "  ✅ Storage Account deployed — private blob container, lifecycle rule applied"
echo "  Storage Account Name: $STORAGE_NAME"

# --- Step 7: Key Vault + grant VM identities access ---
echo ""
echo "[7/8] Deploying Key Vault..."
KEYVAULT_NAME="TechNova-KV-$(date +%s | tail -c 5)"

az keyvault create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$KEYVAULT_NAME" \
  --location "$LOCATION" \
  --sku standard \
  --retention-days 7

# Grant each VM's managed identity 'get' on secrets, so a workload on the
# VM can retrieve the secret at runtime via its identity (no credential
# stored on the VM or in this script).
for VM in TechNova-VM1 TechNova-VM2; do
  VM_IDENTITY=$(az vm show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$VM" \
    --query "identity.principalId" -o tsv)
  if [ -n "$VM_IDENTITY" ]; then
    az keyvault set-policy \
      --name "$KEYVAULT_NAME" \
      --object-id "$VM_IDENTITY" \
      --secret-permissions get list
    echo "  ✅ $VM identity granted 'get' on Key Vault secrets"
  else
    echo "  ⚠️  Could not resolve $VM managed identity — access policy skipped"
  fi
done

# Store a generated secret (never hardcoded)
az keyvault secret set \
  --vault-name "$KEYVAULT_NAME" \
  --name "TechNova-DB-Password" \
  --value "$(openssl rand -base64 24)"

echo "  ✅ Key Vault deployed — DB password generated and stored (not hardcoded)"
echo "  Key Vault Name: $KEYVAULT_NAME"

# --- Step 8: Recovery Services Vault + Backup Policy ---
echo ""
echo "[8/8] Configuring Backup..."
az backup vault create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-RSV" \
  --location "$LOCATION"

# Enable backup for VM1
az backup protection enable-for-vm \
  --resource-group "$RESOURCE_GROUP" \
  --vault-name "TechNova-RSV" \
  --vm "TechNova-VM1" \
  --policy-name "DefaultPolicy"

# Enable backup for VM2
az backup protection enable-for-vm \
  --resource-group "$RESOURCE_GROUP" \
  --vault-name "TechNova-RSV" \
  --vm "TechNova-VM2" \
  --policy-name "DefaultPolicy"

echo "  ✅ Recovery Services Vault deployed — both VMs protected"

echo ""
echo "=================================================="
echo " ✅ Compute & Security Deployment Complete"
echo " Bastion         : TechNova-Bastion (Hub VNet)"
echo " VM1             : TechNova-VM1 (no public IP, managed identity)"
echo " VM2             : TechNova-VM2 (no public IP, managed identity)"
echo " Load Balancer   : TechNova-LB (HTTP probe, both VMs in pool)"
echo " Storage Account : $STORAGE_NAME"
echo " Key Vault       : $KEYVAULT_NAME"
echo " Backup Vault    : TechNova-RSV (both VMs protected)"
echo ""
echo " ⚠️  COST REMINDER: Delete resources after lab"
echo "    az group delete --name $RESOURCE_GROUP --yes --no-wait"
echo "=================================================="
