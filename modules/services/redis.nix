{ config, pkgs, lib, ... }:

{
  # Redis configuration - uses latest stable Redis from nixpkgs
  services.redis.servers."" = {
    enable = true;

    # Store data in centralized /data directory
    # Redis uses append-only file (AOF) for persistence
    dir = "/data/redis";

    # Bind to all interfaces (for K3s and other services)
    bind = "0.0.0.0";
    port = 6379;

    # Security settings
    requirePass = null; # TODO: Set password via agenix
    # requirePassFile = "/run/agenix/redis-password";

    # Performance settings
    settings = {
      # Persistence
      save = [
        [900 1]    # After 900 sec (15 min) if at least 1 key changed
        [300 10]   # After 300 sec (5 min) if at least 10 keys changed
        [60 10000] # After 60 sec if at least 10000 keys changed
      ];
      appendonly = "yes";
      appendfsync = "everysec";

      # Memory
      maxmemory = "512mb";
      maxmemory-policy = "allkeys-lru"; # Evict least recently used keys

      # Logging
      loglevel = "notice";
    };
  };

  # Ensure /data/redis exists with correct permissions
  systemd.tmpfiles.rules = [
    "d /data/redis 0750 redis redis -"
  ];

  # Open firewall for Redis
  networking.firewall.allowedTCPPorts = [ 6379 ];

  # Note: For production, consider:
  # 1. Setting requirePassFile with agenix
  # 2. Using TLS for connections
  # 3. Restricting bind to specific IPs if possible
}
