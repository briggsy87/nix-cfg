{ config, pkgs, lib, ... }:

{
  services.gitea = {
    enable = true;

    # Use latest stable Gitea from nixpkgs
    # NixOS tracks stable releases, updates via nixpkgs channel/flake updates
    package = pkgs.gitea;

    # Store data in centralized /data directory
    stateDir = "/data/gitea";

    # Database configuration
    database = {
      type = "postgres";
      host = "127.0.0.1"; # Local PostgreSQL
      port = 5432;
      name = "gitea";
      user = "gitea";
      password = "gitea"; # TODO: Use agenix for production
      createDatabase = true; # Automatically create database
    };

    # Application settings
    settings = {
      server = {
        DOMAIN = "git.homelab.local"; # Update with your domain
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        ROOT_URL = "https://git.homelab.local/";

        # Disable SSH server (use system SSH if needed)
        DISABLE_SSH = true;
      };

      service = {
        DISABLE_REGISTRATION = true; # Disable public registration
        REQUIRE_SIGNIN_VIEW = false; # Allow anonymous read access
      };

      # Enable container registry (OCI-compliant)
      packages = {
        ENABLED = true;
      };

      # Session and security
      session = {
        PROVIDER = "file";
        COOKIE_SECURE = true;
      };

      security = {
        INSTALL_LOCK = true;
        # SECRET_KEY will be auto-generated in stateDir
      };

      # Logging
      log = {
        MODE = "console";
        LEVEL = "Info";
      };
    };
  };

  # Ensure /data/gitea exists with correct permissions
  # (gitea service creates its own user)
  systemd.tmpfiles.rules = [
    "d /data/gitea 0750 gitea gitea -"
  ];

  # Open firewall for Gitea web UI
  networking.firewall.allowedTCPPorts = [ 3000 ];

  # Note: Gitea's built-in container registry will be available at:
  # git.homelab.local/api/packages/{owner}/container/{package_name}
  # To push: docker push git.homelab.local/username/image:tag

  # TODO:
  # 1. Set up reverse proxy (Traefik) to handle HTTPS
  # 2. Configure database password via agenix
  # 3. Set up admin user after first run
}
