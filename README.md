# TechNova Inc. — Azure Cloud Infrastructure

### Hub-and-Spoke Architecture · Built from a Blank Subscription · No Templates. No Guided Labs. No Safety Net.

**Md Rahat Islam Anik · Self-Directed Case Study · 2026**

[![Live Case Study](https://img.shields.io/badge/Live%20Case%20Study-View%20Now-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-rahatislamanik-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-rahatislamanik--spec-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/rahatislamanik-spec)

---

| 5 Phases | 16+ Azure Services | 2 Days to Build | ~$40 Total Cost |
|:---:|:---:|:---:|:---:|

---

## The Mandate

TechNova Inc. is a growing Canadian tech startup. They've outgrown their on-premise servers and need to move to the cloud — but they need it done right. Secure. Scalable. Cost-efficient. Resilient enough to survive failures without going offline.

As their newly contracted Cloud Administrator, I was handed one mandate: **design and deploy a complete Azure cloud infrastructure from scratch** — with no pre-built templates, no guided labs, and no safety net. Just an Azure subscription, a plan, and the skills to execute it.

Over two focused build sessions, I architected TechNova's entire cloud environment — from the first resource group to the final backup policy. Every decision had a reason. Every resource had a purpose.

---

## Three Goals. One Infrastructure.

**Security First**
Deploy an infrastructure where no resource is exposed unnecessarily. Every VM secured behind Azure Bastion. Every role following least-privilege. Every disk encrypted. Zero public IPs on production VMs.

**Always Available**
Build a system that doesn't go down when a single server fails. Load balanced across backend pools. Health probes replacing failed instances. Recovery Services Vault protecting against data loss.

**Cost Conscious**
Deliver enterprise-grade infrastructure without enterprise-grade waste. Budget alerts, right-sized VMs (Standard B1s), lifecycle policies, and resource cleanup baked in from day one. Total build cost: ~$40.

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

Two Ubuntu Server 22.04 VMs (Standard B1s) were deployed into the private subnets — **zero public IPs**. The only access path is through Azure Bastion, which provides browser-based SSH/RDP without exposing management ports to the internet.

RBAC was configured to enforce least-privilege access across the subscription. Microsoft Defender for Cloud was enabled to provide continuous security posture assessment and threat detection across all resources.

| Component | Configuration |
|---|---|
| VM OS | Ubuntu Server 22.04 |
| VM Size | Standard B1s |
| Public IPs on VMs | 0 |
| Access Method | Azure Bastion |
| Identity Control | RBAC — Least Privilege |
| Threat Detection | Microsoft Defender for Cloud |

---

### Phase 04 — Load Balancing & Resilience
**Azure Load Balancer · Health Probes · Backend Pool**

A single VM — no matter how well configured — is a single point of failure. Phase 04 placed an Azure Load Balancer in front of both VMs, distributing traffic across a backend pool with health probe monitoring.

Health probes continuously verify VM availability. When a probe fails, the Load Balancer automatically removes the unhealthy instance from the rotation — no manual intervention, no visible service interruption.

---

### Phase 05 — Data Protection
**Storage Account · Azure Key Vault · Recovery Services Vault · Azure Backup**

The final layer: data protection and secrets management.

- **Storage Account** — structured blob storage with lifecycle management
- **Azure Key Vault** — centralized secrets and encryption key management; no credentials hardcoded anywhere
- **Recovery Services Vault** — backup policy applied to both VMs
- **Azure Backup** — automated backup schedule with retention policy configured and verified

A hardened VM with no backup is still one bad day away from total data loss. Backup is not optional — it's the last line of defence.

---

## By the Numbers

| Metric | Result |
|---|---|
| Azure services configured | 16+ |
| VNets peered | 3 (Hub-and-Spoke) |
| Public IPs on production VMs | 0 |
| Total build cost | ~$40 |
| Build time | 2 days |

---

## Environment

| Component | Detail |
|---|---|
| Region | East US |
| Resource Group | TechNova-RG |
| VM OS | Ubuntu Server 22.04 |
| VM Size | Standard B1s |
| Architecture | Hub-and-Spoke |
| Access Method | Azure Bastion (no public IPs) |

---

## Tech Stack

`Azure Resource Groups` · `Resource Tags` · `Budget Alerts` · `Virtual Networks (VNet)` · `VNet Peering` · `Network Security Groups` · `Azure Bastion` · `Linux VMs (Ubuntu 22.04)` · `RBAC` · `Microsoft Defender for Cloud` · `Azure Load Balancer` · `Health Probes` · `Storage Account` · `Azure Key Vault` · `Recovery Services Vault` · `Azure Backup`

---

## Skills Demonstrated

`Azure Infrastructure Design` · `Hub-and-Spoke Architecture` · `VNet Peering` · `Network Security Groups` · `Azure Bastion` · `RBAC` · `Least-Privilege Access` · `Microsoft Defender for Cloud` · `Load Balancing` · `Azure Key Vault` · `Secrets Management` · `Azure Backup` · `Cost Governance` · `Resource Tagging` · `Linux Administration`

---

## Live Case Study

The full interactive case study — with architecture diagrams, per-phase documentation, and configuration evidence — is published at:

**[rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure](https://rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure/)**

---

## Author

**Md Rahat Islam Anik**
Cloud Computing & Network Administration · George Brown College · May 2026

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat&logo=linkedin)](https://linkedin.com/in/rahatislamanik)
[![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat&logo=github)](https://github.com/rahatislamanik-spec)
