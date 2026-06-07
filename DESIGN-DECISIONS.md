# TechNova Inc. — Design Decisions

> Architectural rationale for the Azure infrastructure choices made in this case study.
> Every decision reflects a real enterprise trade-off — not just what was available, but why it was chosen.

---

## Hub-and-Spoke VNet Architecture

**Decision:** Three VNets — one Hub, two Spokes (App, DB) — connected via VNet Peering.

**Rationale:** A flat single-VNet design gives every resource the same network boundary. Hub-and-spoke separates concerns: the Hub VNet hosts shared services (Bastion, future firewall), the App VNet hosts workloads, and the DB VNet isolates the data tier. Traffic between spokes must traverse the Hub — creating a natural inspection and control point. This is the standard enterprise Azure pattern for organizations that expect to grow beyond a single workload.

**Alternative considered:** Single VNet with subnet segmentation. Rejected because subnet segmentation alone doesn't provide the same blast radius isolation — a compromise in one subnet can propagate laterally. Separate VNets with controlled peering is a harder boundary.

---

## Azure Bastion — No Public IPs on VMs

**Decision:** All VM NICs have zero public IP addresses. Access exclusively via Azure Bastion in the Hub VNet.

**Rationale:** Every public IP on a production VM is an attack surface. SSH on port 22 exposed to the internet is scanned continuously. Bastion provides browser-based SSH/RDP through the Azure portal over TLS 443 — no jump box to maintain, no public IP to expose, no NSG rule to misconfigure. The only management path to a VM is through an authenticated Azure session.

**Alternative considered:** Jump box VM with public IP. Rejected — a jump box is itself a VM that requires patching, monitoring, and key management. Bastion is a managed PaaS service with none of that overhead.

---

## Standard B1s VMs — Cost-Conscious Sizing

**Decision:** Standard_B1s (1 vCPU, 1GB RAM) for both workload VMs.

**Rationale:** This is a lab environment demonstrating infrastructure patterns, not production compute capacity. B-series burstable VMs are designed for workloads with low baseline CPU and occasional spikes — exactly what a demo environment needs. Total compute cost for the lab build was approximately $40. Right-sizing is itself an enterprise skill — deploying D-series VMs for a lab that runs for two days is wasteful and signals poor cost awareness.

---

## Load Balancer with Health Probes

**Decision:** Azure Standard Load Balancer with HTTP health probe on port 80.

**Rationale:** A single VM behind a load balancer is still a single point of failure, but the pattern demonstrates production-ready architecture. Health probes continuously verify VM availability — when a probe fails, the Load Balancer removes that backend from rotation automatically. No manual intervention, no visible service interruption. The architecture supports adding VMs to the backend pool without reconfiguration.

**Alternative considered:** Application Gateway. Rejected for this scope — App Gateway adds WAF, SSL termination, and path-based routing that are valuable in production but unnecessary for demonstrating basic load distribution and resilience.

---

## Azure Key Vault — Secrets Management

**Decision:** All credentials stored in Key Vault. No secrets hardcoded in scripts or configuration files.

**Rationale:** A credential hardcoded in a script is a credential that will eventually end up in a git repository. Key Vault provides centralized secrets management with access policies, audit logging, soft delete, and rotation support. The DB password generated during deployment is stored as a Key Vault secret — the VM retrieves it at runtime via Managed Identity, never via a hardcoded string.

---

## Recovery Services Vault — Backup from Day One

**Decision:** Azure Backup configured for both VMs using the DefaultPolicy before any workload is deployed.

**Rationale:** Backup configured after a failure is not backup — it's recovery planning after the fact. Enabling backup during initial deployment ensures the first recovery point is captured before any configuration drift or data accumulates. DefaultPolicy provides daily backups with 30-day retention, which is appropriate for a lab environment and demonstrates the operational habit of protecting resources from the moment they exist.

---

## RBAC — Contributor at Resource Group Scope

**Decision:** Role assignment scoped to the Resource Group, not the Subscription.

**Rationale:** Subscription-scoped Contributor access grants the ability to modify or delete any resource in the subscription — including resources outside this project. Resource Group scope limits the blast radius of any misconfiguration to TechNova-RG only. Least-privilege is not just a security principle — it's an operational discipline that prevents accidental interference with other workloads.

---

## Resource Tags — Governance from Day One

**Decision:** All resources tagged with Environment, Project, and Owner at creation time.

**Rationale:** Tags applied retroactively are never complete. Tags applied at resource creation are enforced by policy and inherited consistently. In a real enterprise environment, tags drive cost allocation, compliance reporting, and automated governance policies. Tagging every TechNova resource with `Project=TechNova` means cost reports, Azure Policy, and automation scripts can filter to exactly this workload without ambiguity.

---

*TechNova Inc. is a fictional Canadian tech startup created for portfolio demonstration purposes.*
*All infrastructure was deployed in a real Azure subscription from a blank starting point.*
