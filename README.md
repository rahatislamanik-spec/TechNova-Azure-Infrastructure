# TechNova Inc. — Azure Cloud Infrastructure

A self-directed Azure cloud infrastructure project built from a blank subscription — no templates, no guided labs, no safety net.

**Live case study →** https://rahatislamanik-spec.github.io/TechNova-Azure-Infrastructure/

---

### What was built

A complete, production-ready Azure environment for a fictional Canadian tech startup transitioning from on-premise to cloud — designed around three non-negotiables: security, availability, and cost discipline.

### Five phases

| Phase | Focus | Key Resources |
|---|---|---|
| 01 | Resource Governance | TechNova-RG, tags, budget alert |
| 02 | Hub-and-Spoke Networking | 3 VNets, VNet Peering, NSGs |
| 03 | Compute & Security | 2x Linux VMs, Azure Bastion, RBAC, Defender |
| 04 | Load Balancing & Resilience | Azure LB, health probes, backend pool |
| 05 | Data Protection | Storage Account, Key Vault, Recovery Services Vault, Azure Backup |

### By the numbers

| Metric | Result |
|---|---|
| Azure services configured | 16+ |
| VNets peered | 3 (Hub-and-Spoke) |
| Public IPs on production VMs | 0 |
| Total build cost | ~$40 |

### Environment

| Detail | Value |
|---|---|
| Region | East US |
| Resource Group | TechNova-RG |
| VM OS | Ubuntu Server 22.04 |
| VM Size | Standard B1s |
| Architecture | Hub-and-Spoke |
| Access Method | Azure Bastion (no public IPs) |

---

*Md Rahat Islam Anik · [linkedin.com/in/rahatislamanik](https://linkedin.com/in/rahatislamanik) · [github.com/rahatislamanik-spec](https://github.com/rahatislamanik-spec)*
