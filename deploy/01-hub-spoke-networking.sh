#!/bin/bash
# =============================================================
# TechNova Inc. — Azure Hub-and-Spoke Network Deployment
# Script: 01-hub-spoke-networking.sh
# Phase: 02 — Hub-and-Spoke Networking
#
# Deploys:
#   - Resource Group with tags
#   - Hub VNet (shared services, Bastion)
#   - App Spoke VNet (production workloads)
#   - DB Spoke VNet (isolated database tier)
#   - VNet Peerings (Hub ↔ App, Hub ↔ DB)
#   - Network Security Groups (Web tier, DB tier)
#   - Budget alert
#
# Usage:
#   chmod +x 01-hub-spoke-networking.sh
#   ./01-hub-spoke-networking.sh
#
# Prerequisites:
#   - Azure CLI installed and logged in (az login)
#   - Sufficient permissions on target subscription
#
# TechNova Inc. — fictional portfolio case study
# =============================================================

set -e  # Exit on any error

# --- Variables ---
RESOURCE_GROUP="TechNova-RG"
LOCATION="eastus"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# VNet address spaces
HUB_VNET="TechNova-Hub-VNet"
HUB_PREFIX="10.0.0.0/16"
HUB_BASTION_SUBNET="10.0.1.0/24"

APP_VNET="TechNova-App-VNet"
APP_PREFIX="10.1.0.0/16"
APP_SUBNET="10.1.1.0/24"

DB_VNET="TechNova-DB-VNet"
DB_PREFIX="10.2.0.0/16"
DB_SUBNET="10.2.1.0/24"

echo "=================================================="
echo " TechNova — Hub-and-Spoke Network Deployment"
echo " Resource Group : $RESOURCE_GROUP"
echo " Location       : $LOCATION"
echo "=================================================="

# --- Step 1: Resource Group ---
echo ""
echo "[1/8] Creating Resource Group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --tags Environment=Production Project=TechNova Owner=IT-Operations

# --- Step 2: Hub VNet ---
echo ""
echo "[2/8] Creating Hub VNet..."
az network vnet create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$HUB_VNET" \
  --address-prefix "$HUB_PREFIX" \
  --subnet-name "AzureBastionSubnet" \
  --subnet-prefix "$HUB_BASTION_SUBNET" \
  --location "$LOCATION"

# --- Step 3: App Spoke VNet ---
echo ""
echo "[3/8] Creating App Spoke VNet..."
az network vnet create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$APP_VNET" \
  --address-prefix "$APP_PREFIX" \
  --subnet-name "AppSubnet" \
  --subnet-prefix "$APP_SUBNET" \
  --location "$LOCATION"

# --- Step 4: DB Spoke VNet ---
echo ""
echo "[4/8] Creating DB Spoke VNet..."
az network vnet create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$DB_VNET" \
  --address-prefix "$DB_PREFIX" \
  --subnet-name "DBSubnet" \
  --subnet-prefix "$DB_SUBNET" \
  --location "$LOCATION"

# --- Step 5: VNet Peering — Hub to App ---
echo ""
echo "[5/8] Creating VNet Peering: Hub → App..."
az network vnet peering create \
  --resource-group "$RESOURCE_GROUP" \
  --name "Hub-to-App" \
  --vnet-name "$HUB_VNET" \
  --remote-vnet "$APP_VNET" \
  --allow-vnet-access true \
  --allow-forwarded-traffic true

az network vnet peering create \
  --resource-group "$RESOURCE_GROUP" \
  --name "App-to-Hub" \
  --vnet-name "$APP_VNET" \
  --remote-vnet "$HUB_VNET" \
  --allow-vnet-access true \
  --allow-forwarded-traffic true

# --- Step 6: VNet Peering — Hub to DB ---
echo ""
echo "[6/8] Creating VNet Peering: Hub → DB..."
az network vnet peering create \
  --resource-group "$RESOURCE_GROUP" \
  --name "Hub-to-DB" \
  --vnet-name "$HUB_VNET" \
  --remote-vnet "$DB_VNET" \
  --allow-vnet-access true \
  --allow-forwarded-traffic true

az network vnet peering create \
  --resource-group "$RESOURCE_GROUP" \
  --name "DB-to-Hub" \
  --vnet-name "$DB_VNET" \
  --remote-vnet "$HUB_VNET" \
  --allow-vnet-access true \
  --allow-forwarded-traffic true

# --- Step 7: Network Security Groups ---
echo ""
echo "[7/8] Creating Network Security Groups..."

# Web NSG — App tier
az network nsg create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-Web-NSG" \
  --location "$LOCATION"

az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "TechNova-Web-NSG" \
  --name "Allow-HTTP" \
  --priority 100 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes "*" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 80 \
  --access Allow

az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "TechNova-Web-NSG" \
  --name "Allow-HTTPS" \
  --priority 110 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes "*" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 443 \
  --access Allow

# DB NSG — restrict SQL to App subnet only
az network nsg create \
  --resource-group "$RESOURCE_GROUP" \
  --name "TechNova-DB-NSG" \
  --location "$LOCATION"

az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "TechNova-DB-NSG" \
  --name "Allow-SQL-From-App" \
  --priority 100 \
  --protocol Tcp \
  --direction Inbound \
  --source-address-prefixes "$APP_SUBNET" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges 1433 \
  --access Allow

az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "TechNova-DB-NSG" \
  --name "Deny-All-Inbound" \
  --priority 4096 \
  --protocol "*" \
  --direction Inbound \
  --source-address-prefixes "*" \
  --source-port-ranges "*" \
  --destination-address-prefixes "*" \
  --destination-port-ranges "*" \
  --access Deny

# Associate NSGs to subnets
az network vnet subnet update \
  --resource-group "$RESOURCE_GROUP" \
  --vnet-name "$APP_VNET" \
  --name "AppSubnet" \
  --network-security-group "TechNova-Web-NSG"

az network vnet subnet update \
  --resource-group "$RESOURCE_GROUP" \
  --vnet-name "$DB_VNET" \
  --name "DBSubnet" \
  --network-security-group "TechNova-DB-NSG"

# --- Step 8: Budget Alert ---
echo ""
echo "[8/8] Creating budget alert..."
az consumption budget create \
  --budget-name "TechNova-Lab-Budget" \
  --amount 50 \
  --time-grain Monthly \
  --start-date "$(date +%Y-%m-01)" \
  --end-date "2026-12-31" \
  --resource-group "$RESOURCE_GROUP" \
  --notifications \
    key=BudgetAlert \
    enabled=true \
    operator=GreaterThan \
    threshold=80 \
    contactEmails=rahatislamanik@gmail.com 2>/dev/null || \
  echo "  Budget alert skipped — requires billing scope permissions"

echo ""
echo "=================================================="
echo " ✅ Hub-and-Spoke Network Deployment Complete"
echo " Resource Group : $RESOURCE_GROUP"
echo " Hub VNet       : $HUB_VNET ($HUB_PREFIX)"
echo " App VNet       : $APP_VNET ($APP_PREFIX)"
echo " DB VNet        : $DB_VNET ($DB_PREFIX)"
echo " Peerings       : Hub↔App, Hub↔DB"
echo " NSGs           : Web (HTTP/HTTPS), DB (SQL restricted)"
echo "=================================================="
