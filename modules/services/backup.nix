{ config, pkgs, lib, ... }:

{
  # BorgBackup for centralized /data backups
  # This module sets up borg + borgmatic for automated backups

  services.borgbackup.jobs = {
    homelab-data = {
      # Paths to backup (centralized /data directory)
      paths = [
        "/data"
      ];

      # Backup destination
      # TODO: Update with your NAS or remote backup location
      repo = "/mnt/backups/borg/homelab-data";
      # For remote: "ssh://backup-server/path/to/repo"

      # Encryption
      encryption = {
        mode = "repokey-blake2";
        # Password file (TODO: use agenix)
        # passCommand = "cat /run/agenix/borg-passphrase";
      };

      # Compression
      compression = "auto,zstd";

      # Backup schedule (daily at 2 AM)
      startAt = "daily";

      # Retention policy
      prune.keep = {
        daily = 7;      # Keep 7 daily backups
        weekly = 4;     # Keep 4 weekly backups
        monthly = 6;    # Keep 6 monthly backups
      };

      # Exclusions
      exclude = [
        "*.tmp"
        "*.temp"
        "*.cache"
        # Add service-specific temp directories
        "/data/postgresql/*/pg_wal" # PostgreSQL WAL files (already backed up)
      ];

      # Pre/post hooks
      preHook = ''
        echo "Starting backup of /data at $(date)"
      '';

      postHook = ''
        echo "Backup completed at $(date)"
        # TODO: Add notification (ntfy, healthchecks.io, etc.)
      '';
    };
  };

  # Alternative: Use borgmatic for more advanced configuration
  # Uncomment if you prefer borgmatic
  # services.borgmatic = {
  #   enable = true;
  #   configurations = {
  #     homelab = {
  #       source_directories = [ "/data" ];
  #       repositories = [
  #         { path = "/mnt/backups/borg/homelab-data"; label = "local"; }
  #       ];
  #       encryption_passcommand = "cat /run/agenix/borg-passphrase";
  #       compression = "auto,zstd";
  #       keep_daily = 7;
  #       keep_weekly = 4;
  #       keep_monthly = 6;
  #     };
  #   };
  # };

  # Ensure backup destination exists (if local)
  # Uncomment if backing up to local mount
  # systemd.tmpfiles.rules = [
  #   "d /mnt/backups/borg 0700 root root -"
  # ];

  # Install borg package system-wide for manual operations
  environment.systemPackages = with pkgs; [
    borgbackup
    # borgmatic  # Uncomment if using borgmatic
  ];

  # TODO:
  # 1. Set up backup repository: borg init --encryption=repokey-blake2 /mnt/backups/borg/homelab-data
  # 2. Configure backup passphrase via agenix
  # 3. Set up monitoring/alerting for backup failures
  # 4. Test restore procedure
}
