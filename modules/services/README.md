# Homelab Service Modules

Reusable NixOS service modules for homelab infrastructure.

## Available Modules

- **`postgresql.nix`**: PostgreSQL database server
- **`redis.nix`**: Redis cache/datastore
- **`gitea.nix`**: Git hosting with built-in container registry
- **`backup.nix`**: BorgBackup configuration for /data

## Package Versions

All services use **latest stable** releases from nixpkgs:

| Service    | Package         | Current Version* | Update Method |
|------------|-----------------|------------------|---------------|
| PostgreSQL | `pkgs.postgresql` | 17.x            | nixpkgs update |
| Redis      | `pkgs.redis`    | 7.x             | nixpkgs update |
| Gitea      | `pkgs.gitea`    | 1.22.x          | nixpkgs update |
| Borg       | `pkgs.borgbackup` | 1.4.x         | nixpkgs update |

*Versions as of nixpkgs-unstable 2024-12

## How Updates Work

### Automatic Updates (Recommended)

When you update your flake inputs:

```bash
cd ~/code/nix-cfg
nix flake update

# Review what will change
nix flake show

# Apply updates
ssh root@infra-01 "nixos-rebuild switch --flake github:briggsy87/nix-cfg/homelab-inclusion#infra-01"
```

This will:
1. Pull latest nixpkgs (which includes latest stable package versions)
2. Update all services to new versions
3. Handle database migrations automatically (PostgreSQL)
4. Maintain all data in `/data`

### Pinning Specific Versions

If you need to pin a specific version (e.g., PostgreSQL 16):

```nix
# modules/services/postgresql.nix
services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;  # Pin to v16
  dataDir = "/data/postgresql/16";
};
```

Available PostgreSQL versions in nixpkgs:
- `pkgs.postgresql_12` - PostgreSQL 12
- `pkgs.postgresql_13` - PostgreSQL 13
- `pkgs.postgresql_14` - PostgreSQL 14
- `pkgs.postgresql_15` - PostgreSQL 15
- `pkgs.postgresql_16` - PostgreSQL 16
- `pkgs.postgresql_17` - PostgreSQL 17 (latest)
- `pkgs.postgresql` - Alias to latest (currently 17)

## Data Storage

All services store data in `/data/<service>/`:

```
/data/
├── postgresql/   # PostgreSQL data directory
├── redis/        # Redis persistence (RDB + AOF)
├── gitea/        # Gitea repositories + packages/containers
└── backups/      # Borg backup cache (optional)
```

This centralized structure makes backups simple - just backup `/data`.

## Database Migrations

### PostgreSQL Major Version Upgrades

NixOS provides `postgresql-upgrade` service for major version upgrades:

```bash
# When updating PostgreSQL package to newer major version
ssh root@infra-01

# Check current version
sudo -u postgres psql --version

# After updating flake with new PostgreSQL version
# NixOS will prompt to run pg_upgrade if needed
# Or manually trigger:
systemctl start postgresql-upgrade

# Verify
sudo -u postgres psql --version
```

**Important**: Always backup before major version upgrades!

## Adding a New Service

1. Create module file:
```bash
cd modules/services/
cat > myservice.nix <<'EOF'
{ config, pkgs, ... }:
{
  services.myservice = {
    enable = true;
    dataDir = "/data/myservice";
  };

  systemd.tmpfiles.rules = [
    "d /data/myservice 0750 myservice myservice -"
  ];

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
EOF
```

2. Import in host configuration:
```nix
# hosts/infra-01.nix
imports = [
  ../modules/services/myservice.nix
];
```

3. Apply:
```bash
git add modules/services/myservice.nix
git commit -m "Add myservice module"
git push
ssh root@infra-01 "nixos-rebuild switch --flake github:briggsy87/nix-cfg/homelab-inclusion#infra-01"
```

## Service Dependencies

Some services depend on others:

- **Gitea** depends on **PostgreSQL**
  - Database `gitea` auto-created
  - User `gitea` auto-created with ownership

Dependency order is handled automatically by NixOS systemd unit ordering.

## Security Notes

### Current State (Development)

- ❌ No passwords set (PostgreSQL, Redis)
- ❌ No TLS/SSL encryption
- ❌ Services listen on all interfaces (0.0.0.0)
- ⚠️  Firewall enabled but services accessible from LAN

### Production Hardening (TODO)

- [ ] Configure secrets via agenix
  - PostgreSQL admin password
  - Redis password
  - Gitea database password
  - Borg encryption passphrase
- [ ] Enable TLS for PostgreSQL connections
- [ ] Enable Redis AUTH
- [ ] Restrict service binding to specific IPs
- [ ] Configure Traefik reverse proxy with HTTPS
- [ ] Set up fail2ban
- [ ] Enable SELinux/AppArmor

## Backup Configuration

Backups are configured in `backup.nix` using BorgBackup.

**What's backed up:**
- Entire `/data` directory (PostgreSQL, Redis, Gitea data)

**Retention policy:**
- Daily: 7 backups
- Weekly: 4 backups
- Monthly: 6 backups

**Schedule:** Daily at 2 AM

See `backup.nix` for configuration details.

## Troubleshooting

### Service Won't Start

```bash
# Check status
systemctl status postgresql
systemctl status redis
systemctl status gitea

# Check logs
journalctl -u postgresql -n 50
journalctl -u gitea -xe

# Check data directory permissions
ls -la /data/
```

### Database Connection Issues

```bash
# PostgreSQL
sudo -u postgres psql -l
sudo -u postgres psql -c "SELECT version();"

# From another host
psql -h 192.168.1.11 -U gitea -d gitea

# Redis
redis-cli -h 192.168.1.11 ping
```

### Disk Space Issues

```bash
# Check /data usage
df -h /data
ncdu /data

# PostgreSQL vacuum
sudo -u postgres psql -c "VACUUM FULL;"

# Clean old Redis snapshots
rm /data/redis/dump.rdb.old
```

## References

- [NixOS PostgreSQL Options](https://search.nixos.org/options?query=services.postgresql)
- [NixOS Redis Options](https://search.nixos.org/options?query=services.redis)
- [NixOS Gitea Options](https://search.nixos.org/options?query=services.gitea)
- [BorgBackup Documentation](https://borgbackup.readthedocs.io/)
