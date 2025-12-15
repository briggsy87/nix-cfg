# Pulumi Migration Guide

## Overview

This document outlines the feasibility and path for migrating from Terraform to Pulumi for Proxmox infrastructure management, while keeping NixOS configuration separate.

## Why Pulumi?

### Advantages Over Terraform
1. **Real Programming Language**: Python (which you prefer) instead of HCL
2. **Built-in Secrets Management**: Pulumi has native encryption for secrets (no need for .envrc + Bitwarden)
3. **Better Abstractions**: Classes, functions, loops without `count` hacks
4. **Type Safety**: IDE autocomplete and type checking
5. **State Management**: Similar to Terraform but with better tooling
6. **Testing**: Unit tests with standard Python frameworks

### Trade-offs
1. **Learning Curve**: New CLI and concepts (stacks, programs)
2. **Community Size**: Smaller than Terraform (but growing rapidly)
3. **State Backend**: Pulumi Cloud (free tier) or self-hosted S3/Azure

## Proxmox Support in Pulumi

### Provider: `pulumi-proxmoxve`

**Status**: ✅ **Fully Supported** (as of December 2025)

- **Package**: `pulumi-proxmoxve` (v7.9.0)
- **Python Version**: >=3.9
- **Repository**: https://github.com/muhlba91/pulumi-proxmoxve
- **Documentation**: https://www.pulumi.com/registry/packages/proxmoxve/

### Supported Resources
✅ **LXC Containers** (`CT` module) - Your current use case
✅ **Virtual Machines** (`VM` module) - Including cloud-init
✅ **Storage** - Datastore management
✅ **Networking** - Network bridges, VLANs
✅ **HA** - High availability configuration
✅ **Users/ACLs** - Permission management
✅ **Cloud-init** - For both VMs and containers

**Verdict**: Full feature parity with Terraform for your homelab needs.

## Architecture with Pulumi

### Current Architecture (Terraform + NixOS)
```
homelab-iac/
├── terraform/               # Infrastructure provisioning
│   ├── modules/
│   │   └── lxc-infrastructure/
│   └── environments/
│       └── production/
├── nix-cfg/                 # NixOS configuration (this repo)
│   ├── flake.nix
│   ├── hosts/
│   ├── modules/
│   └── secrets/             # SOPS-encrypted secrets
└── .envrc                   # Bitwarden + env vars (messy)
```

### Proposed Architecture (Pulumi + NixOS)
```
homelab-iac/
├── pulumi/                  # Infrastructure provisioning (Python)
│   ├── __main__.py          # Main program
│   ├── Pulumi.yaml          # Project config
│   ├── Pulumi.production.yaml  # Stack config (encrypted secrets!)
│   ├── requirements.txt     # pulumi-proxmoxve
│   └── resources/
│       ├── containers.py    # LXC container definitions
│       └── vms.py           # VM definitions (if needed)
├── nix-cfg/                 # NixOS configuration (this repo)
│   ├── flake.nix
│   ├── hosts/
│   ├── modules/
│   └── secrets/             # SOPS-encrypted secrets (for NixOS services)
└── .envrc                   # Optional: Just for Pulumi login (1 line)
```

## Secrets Management Strategy

### Two-Tier Approach

#### Tier 1: Pulumi Secrets (Infrastructure Provisioning)
**Use Pulumi's built-in encryption** for secrets needed to **create** infrastructure:
- Proxmox API credentials
- Proxmox node name, storage
- Root passwords (if using password auth)
- SSH keys for initial access

**Storage**: Encrypted in `Pulumi.production.yaml` stack config file (safe to commit!)

**Example**:
```python
import pulumi
import pulumi_proxmoxve as proxmox

# Get secrets from Pulumi config (encrypted)
config = pulumi.Config()
proxmox_password = config.require_secret("proxmox_password")
proxmox_url = config.require("proxmox_url")
proxmox_user = config.require("proxmox_user")

# Provider configuration
provider = proxmox.Provider("proxmoxve",
    endpoint=proxmox_url,
    username=proxmox_user,
    password=proxmox_password,
    insecure=True
)
```

**Set secrets**:
```bash
pulumi config set proxmox_url "https://192.168.1.100:8006"
pulumi config set proxmox_user "root@pam"
pulumi config set --secret proxmox_password "your-password"  # Encrypted!
```

#### Tier 2: SOPS Secrets (NixOS Runtime)
**Use SOPS** for secrets that **NixOS services** need at runtime:
- AWS credentials (for Traefik DNS challenge)
- Database passwords
- API keys for services
- Application secrets

**Storage**: `nix-cfg/secrets/infra-01.yaml` (already set up!)

**Why Keep SOPS?**
- Pulumi doesn't run on the NixOS host
- Services need secrets at runtime, not just deployment time
- SOPS integrates natively with NixOS via `sops-nix`

### Clean Separation of Concerns

```
Pulumi Secrets              SOPS Secrets
     ↓                           ↓
┌──────────────┐         ┌──────────────┐
│  Proxmox API │         │ AWS Route53  │
│  Credentials │         │ Credentials  │
│              │         │              │
│  Used by:    │         │  Used by:    │
│  Pulumi      │         │  Traefik     │
│  Python code │         │  (on host)   │
└──────────────┘         └──────────────┘
```

## Migration Steps

### Phase 1: Setup Pulumi Project (1-2 hours)

1. **Install Pulumi**:
   ```bash
   # Add to your NixOS packages or use nix-shell
   nix-shell -p pulumi

   # Or install globally
   curl -fsSL https://get.pulumi.com | sh
   ```

2. **Create Pulumi project**:
   ```bash
   cd homelab-iac
   mkdir pulumi && cd pulumi

   pulumi new python --name homelab-proxmox
   ```

3. **Install dependencies**:
   ```bash
   pip install pulumi-proxmoxve
   ```

4. **Set secrets**:
   ```bash
   pulumi config set proxmox_url "https://192.168.1.100:8006"
   pulumi config set proxmox_user "root@pam"
   pulumi config set --secret proxmox_password "your-password"
   pulumi config set proxmox_node "pve01"
   ```

### Phase 2: Convert Terraform to Pulumi (2-4 hours)

**Example: Converting LXC infrastructure module**

**Before (Terraform)**:
```hcl
resource "proxmox_lxc" "container" {
  vmid        = var.vmid
  hostname    = var.hostname
  target_node = var.proxmox_node

  rootfs {
    storage = var.proxmox_storage
    size    = var.rootfs_size
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${var.ip_address}/24"
    gw     = var.network_gateway
  }
}
```

**After (Pulumi Python)**:
```python
import pulumi
import pulumi_proxmoxve as proxmox

def create_container(name, vmid, hostname, ip_address):
    """Create an LXC container with standard config."""
    config = pulumi.Config()

    return proxmox.ct.Container(
        name,
        vm_id=vmid,
        node_name=config.require("proxmox_node"),
        description=f"Infrastructure: {hostname}",

        # OS template
        operating_system=proxmox.ct.ContainerOperatingSystemArgs(
            template_file_id=config.require("lxc_template"),
            type="ubuntu",
        ),

        # Resources
        cpu=proxmox.ct.ContainerCpuArgs(
            cores=2,
        ),
        memory=proxmox.ct.ContainerMemoryArgs(
            dedicated=2048,
        ),

        # Disk
        disk=proxmox.ct.ContainerDiskArgs(
            datastore_id=config.require("proxmox_storage"),
            size=8,
        ),

        # Network
        network_interfaces=[
            proxmox.ct.ContainerNetworkInterfaceArgs(
                name="eth0",
                bridge="vmbr0",
                ipv4_address=f"{ip_address}/24",
                ipv4_gateway=config.require("network_gateway"),
            )
        ],

        # Cloud-init / SSH
        initialization=proxmox.ct.ContainerInitializationArgs(
            user_account=proxmox.ct.ContainerInitializationUserAccountArgs(
                keys=[config.require("ssh_public_key")],
            ),
        ),

        started=True,
    )

# Use it:
infra_01 = create_container(
    "infra-01",
    vmid=100,
    hostname="infra-01",
    ip_address="192.168.1.180"
)
```

### Phase 3: Test Deployment (1 hour)

1. **Preview changes**:
   ```bash
   pulumi preview
   ```

2. **Deploy to new test VM**:
   ```bash
   pulumi up
   ```

3. **Verify NixOS deployment still works**:
   ```bash
   # Pulumi creates the VM, then:
   cd ../nix-cfg
   nixos-rebuild switch --flake .#infra-01 --target-host root@192.168.1.180
   ```

### Phase 4: Migration Cutover (30 min)

1. **Import existing Terraform state** (optional):
   ```bash
   # Pulumi can import existing resources
   pulumi import proxmoxve:ct/container:Container infra-01 pve01/lxc/100
   ```

2. **Or destroy and recreate**:
   ```bash
   cd terraform/environments/production
   terraform destroy

   cd ../../../pulumi
   pulumi up
   ```

## Comparison: SOPS with Terraform vs Pulumi

### Option A: Terraform + SOPS (Current)

**Terraform secrets** (via `sops` CLI):
```bash
# Store secrets in SOPS
cat > secrets/terraform.yaml <<EOF
proxmox_password: "your-password"
aws_access_key_id: "AKIA..."
EOF

sops --encrypt --in-place secrets/terraform.yaml

# Use in Terraform via data source
data "sops_file" "secrets" {
  source_file = "../nix-cfg/secrets/terraform.yaml"
}

variable "proxmox_password" {
  default = data.sops_file.secrets.data["proxmox_password"]
  sensitive = true
}
```

**Complexity**: 😐 Medium
- Need `terraform-provider-sops`
- Manage keys for both Terraform and NixOS
- Two separate SOPS files (terraform.yaml, infra-01.yaml)

### Option B: Pulumi + SOPS (Recommended)

**Pulumi secrets** (native encryption):
```bash
pulumi config set --secret proxmox_password "your-password"
# Stored encrypted in Pulumi.production.yaml
```

**SOPS secrets** (NixOS only):
```bash
# Only for NixOS runtime secrets
sops secrets/infra-01.yaml
```

**Complexity**: 😊 Low
- Each tool manages its own secrets
- No cross-tool integration needed
- Pulumi.production.yaml safe to commit (encrypted)
- SOPS only for NixOS services

## .envrc Strategy with Pulumi

### Minimal Approach (Recommended)

```bash
# .envrc - Only for Pulumi login (optional)
# If using Pulumi Cloud (free tier)
export PULUMI_ACCESS_TOKEN=$(bw get password "Pulumi Token")

# Or if self-hosting Pulumi backend on S3
export AWS_ACCESS_KEY_ID=$(bw get username "Homelab AWS")
export AWS_SECRET_ACCESS_KEY=$(bw get password "Homelab AWS")
```

**That's it!** All other secrets go into Pulumi config.

### Or Eliminate .envrc Entirely

If using Pulumi Cloud's free tier, you don't even need `.envrc`:
```bash
pulumi login
# Opens browser for auth, stores token locally
```

## Cost Analysis

### Pulumi Cloud (SaaS Backend)

**Free Tier** (Individual):
- Unlimited stacks
- 3 team members
- Encrypted secrets
- 500 resource operations/month

**Cost**: $0 (sufficient for homelab)

### Self-Hosted Backend (S3)

```python
# pulumi/__main__.py
pulumi.backend.set_backend("s3://my-pulumi-state")
```

**Cost**: S3 storage only (~$0.023/GB/month)

## Recommendation

### Short Term (This Week)
✅ **Stick with Terraform + minimal .envrc**
- Focus on getting Traefik working
- Add SOPS secrets for NixOS services
- Don't migrate mid-project

### Medium Term (Next Month)
🔄 **Migrate to Pulumi**
- Full Python type safety
- Better secrets management
- Easier to extend and test

### Migration Checklist

- [ ] Install Pulumi CLI
- [ ] Create `pulumi/` directory with Python project
- [ ] Set up Pulumi stack config with secrets
- [ ] Convert LXC module to Python function
- [ ] Test deployment on new VM
- [ ] Import or recreate existing infrastructure
- [ ] Update documentation
- [ ] Remove Terraform configs

## Example: Complete Pulumi Setup

I can provide a complete working example if you want to proceed with migration. It would include:

1. `pulumi/__main__.py` - Main program with container definitions
2. `pulumi/Pulumi.yaml` - Project config
3. `pulumi/requirements.txt` - Dependencies
4. `pulumi/resources/` - Reusable Python functions
5. Updated `CLAUDE.md` with Pulumi commands

Would you like me to create this now, or focus on completing the current Terraform + Traefik setup first?

## Next Steps

1. **Decide**: Terraform now + Pulumi later, or migrate now?
2. **If migrating now**: I'll create the complete Pulumi structure
3. **If later**: Document minimal .envrc and complete Traefik setup

Let me know which path you prefer!
