# Secrets Management Setup with sops-nix

## Overview
Using sops-nix to manage secrets for:
- AWS credentials (Route53 DNS challenge)
- Database passwords (PostgreSQL users)
- Traefik configuration
- Future service credentials

## Setup Steps

### 1. Install age (encryption tool)
```bash
nix-shell -p age
```

### 2. Generate age key for the host
```bash
# On infra-01 host
ssh-keyscan localhost | ssh-to-age
# Or use existing SSH host key
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```

### 3. Create .sops.yaml configuration
Place in repo root to define which keys can decrypt which secrets.

### 4. Add sops-nix to flake.nix
Add sops-nix input and module to NixOS configuration.

### 5. Create secrets file
```bash
# Create secrets.yaml
sops secrets/secrets.yaml
```

Example structure:
```yaml
aws_access_key_id: AKIAxxxxx
aws_secret_access_key: xxxxx
postgres_admin_password: xxxxx
gitea_db_password: xxxxx
traefik_cf_api_token: xxxxx  # If using Cloudflare instead of Route53
```

### 6. Reference secrets in NixOS modules
```nix
sops.secrets."aws_access_key_id" = {};
sops.secrets."gitea_db_password" = {
  owner = "gitea";
  group = "gitea";
};

# Use in services
services.gitea.database.passwordFile = config.sops.secrets."gitea_db_password".path;
```

## Traefik Setup Plan

### Services to expose:
1. **Gitea** - git.primeforge.org:443
2. **Adminer** - db.primeforge.org:443
3. **Traefik Dashboard** - traefik.primeforge.org:443 (auth required)

### Traefik Configuration:
- Static config: `/etc/traefik/traefik.yml`
- Dynamic config: `/etc/traefik/dynamic/*.yml`
- Let's Encrypt via DNS-01 challenge (Route53)
- Store certificates in `/data/traefik/acme.json`

## Next Steps
1. Set up sops-nix
2. Migrate existing plaintext secrets
3. Add Traefik module
4. Configure dynamic routes for services
5. Test HTTPS access
