#!/bin/bash
# =============================================================
# TechNova Inc. — Compute, Security & Data Protection Deployment
# Script: 02-compute-security.sh
# Phases: 03 (Compute), 04 (Load Balancer), 05 (Data Protection)
#
# Deploys:
#   - Azure Bastion (secure VM access — no public IPs)
#   - 2x Ubuntu VMs in private App subnet (zero public IPs)
#   - RBAC role assignment (least-privilege)
#   - Azure Load Balancer with health probe
#   - Azure Key Vault with secrets
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
echo "[1/7] Deploying Azure Bastion..."

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

# --- Step 2: Deploy VM1 (no public IP) ---
echo ""
echo "[2/7] Deploying VM1 — TechNova-VM1 (no public IP)..."
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
  --location "$LOCATION"

echo "  ✅ VM1 deployed — zero public IP, Bastion-only access"

# --- Step 3: Deploy VM2 (no public IP) ---
echo ""
echo "[3/7] Deploying VM2 — TechNova-VM2 (no public IP)..."
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
  --location "$LOCATION"

echo "  ✅ VM2 deployed — zero public IP, Bastion-only access"

# --- Step 4: RBAC — Least Privilege ---
echo ""
echo "[4/7] Configuring RBAC — least-privilege assignment..."
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

# --- Step 5: Load Balancer ---
echo ""
echo "[5/7] Deploying Load Balancer..."
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

echo "  ✅ Load Balancer deployed with health probe on port 80"

# --- Step 6: Key Vault ---
echo ""
echo "[6/7] Deploying Key Vault..."
KEYVAULT_NAME="TechNova-KV-$(date +%s | tail -c 5)"

az keyvault create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$KEYVAULT_NAME" \
  --location "$LOCATION" \
  --sku standard \
  --enable-soft-delete true \
  --retention-days 7

# Store a sample secret
az keyvault secret set \
  --vault-name "$KEYVAULT_NAME" \
  --name "TechNova-DB-Password" \
  --value "$(openssl rand -base64 24)"

echo "  ✅ Key Vault deployed — DB password stored as secret (not hardcoded)"
echo "  Key Vault Name: $KEYVAULT_NAME"

# --- Step 7: Recovery Services Vault + Backup Policy ---
echo ""
echo "[7/7] Configuring Backup..."
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
echo " VM1             : TechNova-VM1 (no public IP)"
echo " VM2             : TechNova-VM2 (no public IP)"
echo " Load Balancer   : TechNova-LB (HTTP, health probe)"
echo " Key Vault       : $KEYVAULT_NAME"
echo " Backup Vault    : TechNova-RSV (both VMs protected)"
echo ""
echo " ⚠️  COST REMINDER: Delete resources after lab"
echo "    az group delete --name $RESOURCE_GROUP --yes --no-wait"
echo "=================================================="
