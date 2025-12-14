{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    # Use latest stable PostgreSQL (currently 17)
    # NixOS will handle major version upgrades via postgresql-upgrade service
    package = pkgs.postgresql;  # Tracks latest stable

    # Store data in centralized /data directory
    # Use generic path (NixOS handles version internally)
    dataDir = "/data/postgresql";

    # Enable TCP/IP connections
    enableTCPIP = true;

    # Listen on all interfaces (for K3s and other services to connect)
    settings = {
      listen_addresses = "*";
      max_connections = 100;
      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "2621kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };

    # Authentication configuration
    authentication = pkgs.lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD

      # Local Unix socket connections
      local   all             postgres                                peer
      local   all             all                                     scram-sha-256

      # Network connections (localhost and local network)
      host    all             all             127.0.0.1/32            scram-sha-256
      host    all             all             ::1/128                 scram-sha-256
      host    all             all             192.168.1.0/24          scram-sha-256

      # Reject all other connections
      host    all             all             all                     reject
    '';

    # Initial databases (add more as needed)
    ensureDatabases = [
      "gitea"
    ];

    # Initial users (add more as needed)
    ensureUsers = [
      {
        name = "gitea";
        ensureDBOwnership = true;
      }
    ];

    # Set initial passwords via SQL script
    initialScript = pkgs.writeText "postgresql-init.sql" ''
      -- Set password for postgres superuser (change this!)
      ALTER USER postgres WITH PASSWORD 'nixos123';

      -- Set password for gitea user
      ALTER USER gitea WITH PASSWORD 'gitea';
    '';
  };

  # Ensure /data/postgresql exists with correct permissions
  # Note: PostgreSQL service will create version-specific subdirectories as needed
  systemd.tmpfiles.rules = [
    "d /data/postgresql 0750 postgres postgres -"
  ];

  # Open firewall for PostgreSQL
  networking.firewall.allowedTCPPorts = [ 5432 ];

  # Backup considerations: /data/postgresql contains all data
  # Set up borg/borgmatic separately to backup /data
}
