# ☁️ TechNova Inc. — Azure Cloud Infrastructure
### A Self-Directed Hands-On Technical Portfolio

![Azure](https://img.shields.io/badge/Microsoft%20Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![MS-900](https://img.shields.io/badge/MS--900-Completed-green?style=for-the-badge)
![AZ-900](https://img.shields.io/badge/AZ--900-Completed-green?style=for-the-badge)
![AZ-104](https://img.shields.io/badge/AZ--104-In%20Progress-blue?style=for-the-badge)

---

## 📌 Project Overview

As a self-directed learning project, I simulated being contracted as a Cloud Administrator for **TechNova Inc.**, a fictional Canadian tech startup migrating from on-premise to Azure. I designed and deployed a complete enterprise-grade Azure infrastructure from scratch — covering networking, security, compute, high availability, storage, and backup.

**Three core objectives:**
- 🔐 **Security First** — No exposed resources, Bastion access, least-privilege RBAC
- ⚡ **Always Available** — Load balanced VMs, health probes, Azure Backup
- 💰 **Cost Conscious** — Budget alerts, right-sized VMs, lifecycle policies

---

## 🗺️ Architecture Diagram

![TechNova Architecture](https://raw.githubusercontent.com/rahatislamanik-spec/TechNova-Azure-Infrastructure/main/architecture-diagram.png)

---

## 🏗️ What I Built

| Resource | Details |
|----------|---------|
| **Resource Group** | TechNova-RG · East US · Tagged |
| **Hub VNet** | 10.0.0.0/16 · HubSubnet · AzureBastionSubnet |
| **App VNet** | 10.1.0.0/16 · AppSubnet |
| **DB VNet** | 10.2.0.0/16 · DBSubnet |
| **VNet Peering** | Hub↔App · Hub↔DB · Fully Synchronized |
| **NSG (App)** | Allow HTTP:80 · Allow HTTPS:443 → AppSubnet |
| **NSG (DB)** | Allow SQL:1433 from AppSubnet only → DBSubnet |
| **Virtual Machines** | TechNova-VM1 + VM2 · Ubuntu 22.04 · AppSubnet |
| **Load Balancer** | TechNova-LB · Backend Pool · Health Probe · LB Rule |
| **Azure Bastion** | Secure VM access · No public IP on VMs |
| **Storage Account** | technovastorage01 · LRS · Hot Tier · Lifecycle Policy |
| **Key Vault** | TechNova-KV01 · DB Password Secret |
| **Recovery Vault** | TechNova-RSV · VM1 + VM2 Backup Protected |
| **RBAC** | VM Contributor · Least Privilege |

---

## 🔒 Security Highlights

- ✅ No public IPs on VMs — all access via Azure Bastion
- ✅ Network segmentation — App and DB layers isolated
- ✅ DB NSG only allows traffic from AppSubnet (port 1433)
- ✅ Secrets stored in Key Vault — not hardcoded
- ✅ RBAC least privilege — VM Contributor only
- ✅ Secure transfer enforced on Storage Account
- ✅ TLS 1.2 minimum on all storage operations

---

## 🛠️ Technologies Used

- **Azure Portal** — Resource provisioning and management
- **Azure Virtual Networks** — Hub-and-spoke architecture
- **Network Security Groups** — Layer 4 traffic filtering
- **Azure Bastion** — Secure RDP/SSH without public IPs
- **Azure Load Balancer** — Standard SKU, health probes
- **Azure Key Vault** — Secrets and key management
- **Azure Backup** — VM protection and recovery
- **Azure Storage** — Blob storage with lifecycle management
- **RBAC** — Role-based access control
- **PowerShell / Cloud Shell** — Automation and troubleshooting

---

## 📚 Certifications

| Certification | Status |
|--------------|--------|
| Microsoft 365 Fundamentals (MS-900) | ✅ Completed |
| Azure Fundamentals (AZ-900) | ✅ Completed |
| Azure Administrator (AZ-104) | 🔄 In Progress |

---

## 🚀 What's Next

- [ ] Complete AZ-104 certification exam
- [ ] Deploy full environment using Bicep/IaC templates
- [ ] Implement Azure Site Recovery for disaster recovery
- [ ] Pursue AZ-500 (Azure Security Engineer) certification

---

## 👤 About Me

**Md Rahat Islam Anik**
Cloud Computing & Network Administration Student | Azure Enthusiast

📍 Toronto, Canada
🔗 [LinkedIn](https://www.linkedin.com/in/rahat-islam-7120a4230/)

---

*Self-directed learning project to build practical, job-ready Azure cloud administration skills.*
