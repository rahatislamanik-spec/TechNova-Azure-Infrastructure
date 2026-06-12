# TechNova Inc. — Azure Cloud Infrastructure
> **Status:** Portfolio Complete — v1.0

### Azure Infrastructure Case Study · Hub-and-Spoke Networking · Screenshot-Evidenced Build

**Md Rahat Islam Anik · Azure Infrastructure Case Study · 2026**

[![Live Case Study](https://img.shields.io/badge/Live%20Case%20Study-View%20Now-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-rahatislamanik-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-rahatislamanik--spec-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahatislamanik-spec)

---

| 5 Phases | 16+ Azure Resources/Services | Screenshot Evidence | Cost-Aware Lab Build |
|:---:|:---:|:---:|:---:|

---

## The Problem

TechNova Inc. — a growing Canadian tech startup — had outgrown their on-premise servers with no cloud presence, no disaster recovery, no network segmentation, and no scalable path forward. A single server failure would take the entire operation offline.

## The Solution

A production-style Azure infrastructure lab built from a blank subscription — hub-and-spoke VNet architecture, zero public IPs on workload VM NICs, Azure Bastion for secure access, Load Balancer with health probes, Key Vault for secrets management, and Recovery Services Vault backup configuration.

**16+ Azure resources/services. Cost-aware build. Evidence mapped to screenshots.**

---

## The Mandate

TechNova Inc. is a growing Canadian tech startup. They've outgrown their on-premise servers and need to move to the cloud — but they need it done right. Secure. Scalable. Cost-efficient. Resilient enough to survive failures without going offline.

For this case study, I worked from a blank Azure subscription and a business-style scenario: **design and deploy a secure, segmented, cost-aware Azure infrastructure foundation**. The goal was to show the same planning and implementation thinking expected from a junior Azure or cloud administrator.

The build moves from governance to networking, compute, access, load balancing, and backup evidence. Every phase is tied to portal screenshots so the project can be reviewed without relying only on claims.

---

## Three Goals. One Infrastructure.

**Security First**
Deploy an infrastructure where workload VMs are not directly exposed to the internet. Management access is handled through Azure Bastion, network exposure is controlled with NSGs, and RBAC assignments are reviewed at resource scope.

**Always Available**
Build a system that doesn't go down when a single server fails. Load balanced across backend pools. Health probes replacing failed instances. Recovery Services Vault protecting against data loss.

**Cost Conscious**
Deliver a cost-aware lab environment without unnecessary resource sprawl. Budget alerts, lab-sized VM choices, tagging, and cleanup planning are included from day one.

---

## Five Phases

### Phase 01 — Resource Governance
**TechNova-RG · Resource Tags · Budget Alert**

Before a single VM is deployed, the environment needs structure. Phase 01 established TechNova's resource governance foundation — a dedicated resource group, consistent tagging across all resources, and a budget alert to enforce cost discipline from day one.

A resource group without tags is a resource group no one can audit. Tags aren't optional overhead — they're the difference between a manageable cloud environment and a sprawling mess.

---

### Phase 02 — Hub-and-Spoke Networking
**3 VNets · VNet Peering · Network Security Groups**

TechNova's network was built on a hub-and-spoke architecture — the standard pattern for enterprise Azure environments that need centralized security without sacrificing segmentation.

- **Hub VNet** — shared services, bastion, and centralized egress
- **Spoke VNet 1** — production workloads
- **Spoke VNet 2** — isolated secondary workloads

VNet Peering connects the spokes to the hub without traffic routing through the public internet. Network Security Groups enforce inbound and outbound rules at the subnet level — a second layer of control on top of VM-level security.

```
[Hub VNet]
  ├── Azure Bastion
  ├── NSGs
  └── VNet Peering
       ├── [Spoke VNet 1] — Production
       └── [Spoke VNet 2] — Secondary
```

---

### Phase 03 — Compute & Security
**2x Linux VMs · Azure Bastion · RBAC · Microsoft Defender**

Two Ubuntu Server 22.04 VMs were deployed into private subnets — **zero public IPs on the VM NICs**. The intended management path is Azure Bastion, which provides browser-based SSH/RDP without exposing management ports directly to the internet.

RBAC was reviewed and demonstrated at the resource-group scope. The evidence shows Owner and Virtual Machine Contributor assignments; in a production rollout, privileged access would be reduced further with named groups, break-glass controls, and periodic access reviews.

| Component | Configuration |
|---|---|
| VM OS | Ubuntu Server 22.04 |
| VM Size | Lab-sized Azure VM SKU shown in screenshots |
| Public IPs on VM NICs | 0 |
| Access Method | Azure Bastion |
| Identity Control | RBAC reviewed at resource scope |
| Threat Detection | Microsoft Defender for Cloud |

---

### Phase 04 — Load Balancing & Resilience
**Azure Load Balancer · Health Probes · Backend Pool**

A single VM — no matter how well configured — is a single point of failure. Phase 04 placed an Azure Load Balancer in front of both VMs, distributing traffic across a backend pool with health probe monitoring.

Health probes continuously verify VM availability. When a probe fails, Azure Load Balancer can stop sending traffic to that unhealthy backend instance, depending on the configured rule and probe behavior.

---

### Phase 05 — Data Protection
**Storage Account · Azure Key Vault · Recovery Services Vault · Azure Backup**

The final layer: data protection and secrets management.

- **Storage Account** — structured blob storage with lifecycle management
- **Azure Key Vault** — centralized secret storage pattern; no secret values are exposed in this repository
- **Recovery Services Vault** — backup policy applied to both VMs
- **Azure Backup** — backup policy and retention settings configured and evidenced in screenshots

A hardened VM with no backup is still one bad day away from total data loss. Backup is not optional — it's the last line of defence.

---

## By the Numbers

| Metric | Result |
|---|---|
| Azure services configured | 16+ |
| VNets peered | 3 (Hub-and-Spoke) |
| Public IPs on workload VM NICs | 0 |
| Evidence screenshots | 33 Azure Portal screenshots |
| Build style | Cost-aware Azure lab implementation |

---

## Environment

| Component | Detail |
|---|---|
| Region | East US |
| Resource Group | TechNova-RG |
| VM OS | Ubuntu Server 22.04 |
| VM Size | Lab-sized Azure VM SKU shown in screenshots |
| Architecture | Hub-and-Spoke |
| Access Method | Azure Bastion (no public IPs) |

---

## Evidence Status

| Area | Status | Evidence |
|---|---|---|
| Resource group, tags, and budget | Implemented | Azure Portal screenshots |
| Hub-and-spoke VNets and peering | Implemented | Azure Portal screenshots |
| VM deployment and private NICs | Implemented | Azure Portal screenshots |
| NSG segmentation | Implemented | Azure Portal screenshots |
| Azure Load Balancer, backend pool, and probe | Implemented | Azure Portal screenshots |
| Key Vault secret storage pattern | Implemented | Azure Portal screenshots; secret value not exposed |
| Recovery Services Vault and backup policy | Implemented | Azure Portal screenshots |
| Azure Firewall, Application Gateway, Private Endpoints, Azure SQL, PIM, Azure Policy | Reference architecture only | Not implemented in this repo |
| Production rollout | Not performed | Lab environment; assumptions documented below |

See [docs/evidence-map.md](docs/evidence-map.md) for the screenshot-by-screenshot evidence map.

---

## Limitations and Production Assumptions

This is a portfolio lab, not a production tenant handover. A production rollout would still need:

- named Entra ID groups instead of direct privileged user assignments
- break-glass account design and access review process
- Azure Policy assignments for governance enforcement
- diagnostic settings, Log Analytics, and alert rules
- backup restore testing, not only backup policy configuration
- formal change control, rollback plan, and runbook documentation
- private endpoint and firewall design if the application/data layer required it

---

## Tech Stack

`Azure Resource Groups` · `Resource Tags` · `Budget Alerts` · `Virtual Networks (VNet)` · `VNet Peering` · `Network Security Groups` · `Azure Bastion` · `Linux VMs (Ubuntu 22.04)` · `RBAC` · `Microsoft Defender for Cloud` · `Azure Load Balancer` · `Health Probes` · `Storage Account` · `Azure Key Vault` · `Recovery Services Vault` · `Azure Backup`

---

## Deployment Scripts

The full infrastructure can be deployed using Azure CLI. Scripts are in the [`deploy/`](deploy/) folder — run in order.

| Script | Phase | What It Deploys |
|---|---|---|
| [01-hub-spoke-networking.sh](deploy/01-hub-spoke-networking.sh) | Phase 02 | Resource Group, 3 VNets, VNet Peering, NSGs, Budget Alert |
| [02-compute-security.sh](deploy/02-compute-security.sh) | Phase 03–05 | Bastion, 2x VMs (no public IPs), RBAC, Load Balancer, Key Vault, Backup |

```bash
# Clone and deploy
git clone https://github.com/rahatislamanik-spec/TechNova-Azure-Infrastructure.git
cd TechNova-Azure-Infrastructure/deploy

# Login to Azure
az login

# Phase 1: Network foundation
chmod +x 01-hub-spoke-networking.sh
./01-hub-spoke-networking.sh

# Phase 2: Compute and security
chmod +x 02-compute-security.sh
./02-compute-security.sh

# Cleanup after lab (cost safety)
az group delete --name TechNova-RG --yes --no-wait
```

> See [DESIGN-DECISIONS.md](DESIGN-DECISIONS.md) for architectural rationale behind every major choice.

---

## Skills Demonstrated

`Azure Infrastructure Design` · `Hub-and-Spoke Architecture` · `VNet Peering` · `Network Security Groups` · `Azure Bastion` · `RBAC Review` · `Microsoft Defender for Cloud` · `Load Balancing` · `Azure Key Vault` · `Secrets Management Pattern` · `Azure Backup` · `Cost Governance` · `Resource Tagging` · `Linux Administration`

---

## Live Case Study

The full interactive case study — with architecture diagrams, per-phase documentation, and configuration evidence — is published at:

**[rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure](https://rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure/)**

---

## Author

**Md Rahat Islam Anik**
Azure Administrator · Cloud & Infrastructure Operations Specialist · Toronto, Canada

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/rahatislamanik-spec)
