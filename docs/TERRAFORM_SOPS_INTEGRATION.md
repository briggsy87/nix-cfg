# Terraform + SOPS Integration Guide

## Overview

This document explains how to use SOPS for secrets management with Terraform, alongside the existing SOPS setup for NixOS.

## Architecture

### Two-Tier Secret Management

```
┌─────────────────────────────────────────────────────────┐
│                    Secrets Strategy                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Tier 1: Terraform Provisioning Secrets                 │
│  ├── Purpose: Create infrastructure                     │
│  ├── Tool: SOPS (terraform-provider-sops)               │
│  ├── File: secrets/terraform.yaml                       │
│  └── Used by: Terraform                                 │
│                                                          │
│  Tier 2: NixOS Runtime Secrets                          │
│  ├── Purpose: Configure services                        │
│  ├── Tool: SOPS (sops-nix)                              │
│  ├── File: secrets/infra-01.yaml                        │
│  └── Used by: NixOS services (Traefik, PostgreSQL)      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Setup

### 1. Add SOPS Provider to Terraform

**terraform/environments/production/providers.tf**:
```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.50"
    }

    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_api_url
  username = var.proxmox_user
  password = data.sops_file.terraform_secrets.data["proxmox_password"]
  insecure = var.proxmox_tls_insecure
}
```

### 2. Create Terraform Secrets File

**secrets/terraform.yaml**:
```yaml
# Proxmox credentials
proxmox_password: "your-proxmox-password"

# AWS credentials (for Terraform S3 backend)
aws_access_key_id: "AKIA..."
aws_secret_access_key: "secret..."
```

### 3. Encrypt Terraform Secrets

**Update .sops.yaml** to include Terraform secrets:
```yaml
keys:
  - &infra-01 age1dx8p7qapyqwjt5fny7qen0p3k3e74nkf399t8f3zajukntctzquq7qahd8
  - &admin age17z3dr8u7tyr4h38hx9q47av7eszhha4h0huk9f2pu9r8q557t42qttj4cv

creation_rules:
  # NixOS host secrets
  - path_regex: secrets/infra-01\.yaml$
    key_groups:
      - age:
          - *infra-01
          - *admin

  # Terraform secrets (admin only - not needed on hosts)
  - path_regex: secrets/terraform\.yaml$
    key_groups:
      - age:
          - *admin
```

**Encrypt the file**:
```bash
cd nix-cfg
sops --encrypt secrets/terraform.yaml > secrets/terraform.yaml.enc
mv secrets/terraform.yaml.enc secrets/terraform.yaml
```

### 4. Use Secrets in Terraform

**terraform/environments/production/main.tf**:
```hcl
# Load SOPS-encrypted secrets
data "sops_file" "terraform_secrets" {
  source_file = "${path.module}/../../../nix-cfg/secrets/terraform.yaml"
}

# Use secrets in provider configuration
provider "proxmox" {
  endpoint = var.proxmox_api_url
  username = var.proxmox_user
  password = data.sops_file.terraform_secrets.data["proxmox_password"]
}

# Pass secrets to resources
module "infra_01" {
  source = "../../modules/lxc-infrastructure"

  vmid                = 100
  hostname            = "infra-01"
  ip_address          = "192.168.1.180"
  proxmox_password    = data.sops_file.terraform_secrets.data["proxmox_password"]
}
```

## Complete Example

### Directory Structure
```
homelab-iac/
├── terraform/
│   ├── environments/
│   │   └── production/
│   │       ├── main.tf              # Uses sops_file data source
│   │       ├── providers.tf         # Includes sops provider
│   │       └── variables.tf
│   └── modules/
│       └── lxc-infrastructure/
└── nix-cfg/
    ├── .sops.yaml                   # Defines encryption rules
    └── secrets/
        ├── terraform.yaml           # Terraform secrets (encrypted)
        └── infra-01.yaml            # NixOS secrets (encrypted)
```

### Example: terraform.yaml (Encrypted)

**Before encryption** (local editing only):
```yaml
# Terraform provisioning secrets
proxmox_password: "supersecret123"

# AWS for Terraform S3 backend
aws_access_key_id: "AKIAIOSFODNN7EXAMPLE"
aws_secret_access_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

**After encryption** (safe to commit):
```yaml
proxmox_password: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
aws_access_key_id: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
aws_secret_access_key: ENC[AES256_GCM,data:...,iv:...,tag:...,type:str]
sops:
  age:
    - recipient: age17z3dr8u7tyr4h38hx9q47av7eszhha4h0huk9f2pu9r8q557t42qttj4cv
      enc: |
        -----BEGIN AGE ENCRYPTED FILE-----
        ...
        -----END AGE ENCRYPTED FILE-----
  lastmodified: "2025-12-15T16:00:00Z"
  version: 3.11.0
```

## Workflow

### Editing Terraform Secrets

```bash
cd nix-cfg

# Edit encrypted file
sops secrets/terraform.yaml

# Changes are automatically encrypted on save
```

### Running Terraform

```bash
cd terraform/environments/production

# Initialize (only needed first time or when providers change)
terraform init

# Plan (SOPS provider decrypts secrets automatically)
terraform plan

# Apply
terraform apply
```

### Editing NixOS Secrets

```bash
cd nix-cfg

# Edit encrypted file
sops secrets/infra-01.yaml

# Deploy to host
nixos-rebuild switch --flake .#infra-01 --target-host root@192.168.1.180
```

## Comparison with .envrc Approach

### Current Approach (.envrc + Bitwarden)

**Pros**:
- Simple to understand
- Bitwarden CLI integration
- No additional Terraform provider needed

**Cons**:
- Secrets not in version control
- Requires Bitwarden CLI setup on every machine
- Manual synchronization between team members
- Shell environment pollution

### SOPS Approach

**Pros**:
- ✅ Secrets safely committed to git (encrypted)
- ✅ Same tool for Terraform and NixOS
- ✅ Cryptographic key-based access (age)
- ✅ No external dependencies (Bitwarden)
- ✅ Audit trail in git history
- ✅ Easy team member onboarding (just add their age key)

**Cons**:
- 😐 Need terraform-provider-sops
- 😐 Slightly more complex initial setup
- 😐 Must manage age keys

## Simplified .envrc with SOPS

If using SOPS for secrets, `.envrc` becomes optional or minimal:

### Option 1: Minimal .envrc (Only for AWS S3 Backend)

```bash
#!/bin/bash
# .envrc - Minimal version for SOPS users

# Only needed if using AWS S3 for Terraform backend
# (These could also be in terraform.yaml via SOPS)
if command -v bw &> /dev/null; then
  if [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw unlock --raw)
  fi

  export AWS_ACCESS_KEY_ID=$(bw get username "Homelab AWS")
  export AWS_SECRET_ACCESS_KEY=$(bw get password "Homelab AWS")

  echo "✓ AWS credentials loaded (for Terraform S3 backend)"
fi
```

### Option 2: Pure SOPS (No .envrc)

Move ALL secrets to SOPS:

**secrets/terraform.yaml**:
```yaml
# Proxmox
proxmox_password: "secret"

# AWS (for S3 backend AND Route53)
aws_access_key_id: "AKIA..."
aws_secret_access_key: "secret..."
aws_region: "us-east-1"
```

**terraform backend config**:
```hcl
terraform {
  backend "s3" {
    bucket = "homelab-terraform-state"
    key    = "production/terraform.tfstate"
    region = data.sops_file.terraform_secrets.data["aws_region"]

    # NOTE: S3 backend doesn't support dynamic values
    # Must use environment variables or -backend-config flag
  }
}
```

**Initialize with SOPS values**:
```bash
# Export from SOPS to env vars for backend init
export AWS_ACCESS_KEY_ID=$(sops -d secrets/terraform.yaml | yq '.aws_access_key_id')
export AWS_SECRET_ACCESS_KEY=$(sops -d secrets/terraform.yaml | yq '.aws_secret_access_key')

terraform init
```

## Best Practices

### 1. Separate Secrets by Purpose

```
secrets/
├── terraform.yaml          # Provisioning secrets (admin only)
├── infra-01.yaml          # Runtime secrets (host + admin)
└── common.yaml            # Shared secrets (all hosts + admin)
```

### 2. Principle of Least Privilege

- **Terraform secrets**: Only admin age key
- **Host secrets**: Host key + admin key
- **Common secrets**: All host keys + admin key

### 3. Never Commit Unencrypted Secrets

```bash
# .gitignore
secrets/*.yaml.dec
secrets/*.yaml.tmp
secrets/.*.swp
```

### 4. Rotate Keys Regularly

```bash
# Generate new age key
age-keygen -o ~/.config/sops/age/keys-2025.txt

# Add to .sops.yaml
# Re-encrypt all files
find secrets/ -name "*.yaml" -exec sops updatekeys {} \;
```

## Migration from .envrc to SOPS

### Step 1: Create Terraform Secrets File

```bash
cd nix-cfg

# Create unencrypted file
cat > secrets/terraform.yaml <<EOF
proxmox_password: "$(bw get password 'Proxmox Root')"
aws_access_key_id: "$(bw get username 'Homelab AWS')"
aws_secret_access_key: "$(bw get password 'Homelab AWS')"
EOF
```

### Step 2: Encrypt It

```bash
sops --encrypt --in-place secrets/terraform.yaml
```

### Step 3: Update Terraform

Add `sops` provider and `sops_file` data source (see above).

### Step 4: Test

```bash
cd terraform/environments/production
terraform plan

# Should work without any environment variables set!
```

### Step 5: Simplify .envrc

Remove or comment out everything except AWS credentials for S3 backend initialization (if needed).

### Step 6: Commit

```bash
git add secrets/terraform.yaml .gitignore
git commit -m "feat: migrate Terraform secrets to SOPS"
```

## Troubleshooting

### Error: "failed to get the data key"

**Cause**: Your age key isn't in the recipients list for this file.

**Fix**:
```bash
# Check which keys can decrypt
sops --decrypt secrets/terraform.yaml

# Add your key to .sops.yaml
# Re-encrypt
sops updatekeys secrets/terraform.yaml
```

### Error: "no valid sops data found"

**Cause**: File isn't encrypted or corrupted.

**Fix**:
```bash
# Re-encrypt
sops --encrypt --in-place secrets/terraform.yaml
```

### Error: "config file not found"

**Cause**: Not running from nix-cfg directory.

**Fix**:
```bash
cd nix-cfg
sops secrets/terraform.yaml
```

## Summary

### What Goes Where

| Secret Type | Tool | File | Used By | Encryption |
|------------|------|------|---------|-----------|
| Proxmox API password | SOPS | terraform.yaml | Terraform | age (admin key) |
| AWS credentials | SOPS | terraform.yaml | Terraform S3 backend | age (admin key) |
| AWS credentials | SOPS | infra-01.yaml | Traefik (DNS challenge) | age (host + admin) |
| Database passwords | SOPS | infra-01.yaml | PostgreSQL, Gitea | age (host + admin) |
| Root password | None | terraform.tfvars | Terraform (optional) | None (use SSH keys) |
| SSH keys | None | ~/.ssh/ | Cloud-init | None (public keys) |

### Recommended: Hybrid Approach

**Short term**: Keep `.envrc` for now, add SOPS for NixOS secrets.

**Long term**: Migrate Terraform to SOPS or Pulumi for complete secret management.

**Best approach**: Migrate to Pulumi (see PULUMI_MIGRATION.md) for native secret management + Python.
