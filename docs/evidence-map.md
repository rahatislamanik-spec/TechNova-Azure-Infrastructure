# TechNova Azure Infrastructure Evidence Map

This map links each evidence screenshot to the claim it supports. The project is presented as a production-style Azure lab, not a production tenant handover.

## Architecture Reference

| File | Purpose | Status |
|---|---|---|
| `assets/diagrams/technova-reference-architecture.jpg` | Target-state architecture reference used for design discussion | Reference only; not all services shown were implemented |

## Screenshot Evidence

| File | Evidence shown |
|---|---|
| `assets/screenshots/technova-01-technova-rg-all-resources-overview-in-azure-portal.jpg` | Resource group overview and deployed Azure resources |
| `assets/screenshots/technova-02-resource-group-page-2-showing-full-resource-list.jpg` | Additional resource group inventory |
| `assets/screenshots/technova-03-resource-tags-applied-environment-project-owner.jpg` | Resource tags for environment, project, and owner metadata |
| `assets/screenshots/technova-04-resource-group-review-and-create-confirmation.jpg` | Resource group creation review |
| `assets/screenshots/technova-05-app-vnet-address-space-and-subnet-configuration.jpg` | App VNet address space and subnet configuration |
| `assets/screenshots/technova-06-app-vnet-subnet-details-and-peering-settings.jpg` | App VNet subnet and peering details |
| `assets/screenshots/technova-07-db-vnet-isolated-database-network-configuration.jpg` | DB VNet isolation configuration |
| `assets/screenshots/technova-08-all-three-vnets-deployed-hub-app-and-db.jpg` | Hub, app, and DB VNets deployed |
| `assets/screenshots/technova-09-vnet-peering-configuration-between-hub-and-spokes.jpg` | VNet peering setup |
| `assets/screenshots/technova-10-vnet-peerings-confirmed-connected-status-verified.jpg` | Peering connection status |
| `assets/screenshots/technova-11-ip-addressing-and-subnet-configuration-details.jpg` | IP addressing and subnet details |
| `assets/screenshots/technova-12-azure-marketplace-resource-creation-workflow.jpg` | Azure resource creation workflow |
| `assets/screenshots/technova-13-technova-vm1-overview-and-configuration-details.jpg` | VM1 configuration and private networking |
| `assets/screenshots/technova-14-technova-vm2-overview-and-configuration-details.jpg` | VM2 configuration and private networking |
| `assets/screenshots/technova-15-vm2-successfully-deployed-and-running.jpg` | VM2 running state |
| `assets/screenshots/technova-16-rbac-role-assignments-on-resource-group.jpg` | RBAC role assignment review at resource scope |
| `assets/screenshots/technova-17-web-nsg-overview-and-inbound-rules.jpg` | Web NSG overview and inbound rules |
| `assets/screenshots/technova-18-nsg-http-port-80-and-https-port-443-rules-configured.jpg` | HTTP/HTTPS NSG rules |
| `assets/screenshots/technova-19-nsg-additional-http-https-rule-confirmation.jpg` | Additional NSG rule confirmation |
| `assets/screenshots/technova-20-db-nsg-database-layer-network-security-group.jpg` | DB NSG configuration |
| `assets/screenshots/technova-21-db-nsg-sql-port-1433-restricted-to-appsubnet-only.jpg` | SQL port rule restricted to application subnet |
| `assets/screenshots/technova-22-nsg-associated-to-subnet-traffic-filtering-active.jpg` | NSG associated to subnet |
| `assets/screenshots/technova-23-technova-lb-load-balancer-overview-and-configuration.jpg` | Load Balancer overview and frontend configuration |
| `assets/screenshots/technova-24-load-balancing-rule-port-80-traffic-distribution.jpg` | Load balancing rule for port 80 |
| `assets/screenshots/technova-25-backend-pool-vm1-and-vm2-registered-and-active.jpg` | Backend pool members |
| `assets/screenshots/technova-26-health-probe-continuously-checking-vm-availability.jpg` | Health probe configuration |
| `assets/screenshots/technova-27-storage-account-overview-and-access-configuration.jpg` | Storage account overview |
| `assets/screenshots/technova-28-blob-container-storage-container-configured.jpg` | Blob container configuration |
| `assets/screenshots/technova-29-key-vault-secret-storage-pattern.jpg` | Key Vault secret storage pattern; value not shown |
| `assets/screenshots/technova-30-key-vault-overview-technova-kv01-configuration.jpg` | Key Vault overview |
| `assets/screenshots/technova-31-recovery-services-vault-backup-management.jpg` | Recovery Services Vault backup management |
| `assets/screenshots/technova-32-azure-backup-vm-backup-policy-configured.jpg` | Azure Backup policy configuration |
| `assets/screenshots/technova-33-technova-rg-final-lab-resource-inventory.jpg` | Final resource group inventory |

## Not Claimed As Implemented

The reference architecture image includes services that are common in more mature Azure landing zones. The following are not claimed as implemented evidence in this repository:

- Azure Firewall
- Azure Application Gateway
- Azure Private Endpoints
- Azure SQL
- VM Scale Sets
- Azure Policy enforcement
- Microsoft Entra PIM
- Log Analytics and Azure Monitor alerting

