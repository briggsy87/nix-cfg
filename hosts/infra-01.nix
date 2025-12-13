{ config, pkgs, hostname, username, ... }:

{
  imports = [
    # Disko disk configuration (must be imported for fileSystems generation)
    ./infra-01-disko.nix
    # Import service modules
    ../modules/services/postgresql.nix
    #../modules/services/redis.nix
    ../modules/services/gitea.nix
    # TODO: Enable backup.nix after configuring passphrase
    #../modules/services/backup.nix
  ];

  # Bootloader - systemd-boot for UEFI
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable serial console for Proxmox
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" ];
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
  };

  # Nix settings (standard across all hosts)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Bootloader - GRUB is configured above via boot.loader.grub.devices

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking = {
    hostName = hostname;

    # Use DHCP temporarily for debugging - will get static IP from router
    useDHCP = true;

    # Firewall configuration
    firewall = {
      enable = true;
      # Service-specific ports are opened in their respective modules
      # Add any additional ports here if needed
      allowedTCPPorts = [
        22  # SSH
        # 5432 opened by postgresql.nix
        # 6379 opened by redis.nix
        # 3000 opened by gitea.nix
      ];
    };
  };

  # Locale & timezone
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # SSH server for remote management
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password"; # Key-based auth only
      PasswordAuthentication = false;
    };
  };

  # Root user configuration
  users.users.root = {
    # TEMPORARY: Enable password authentication for debugging console access
    # TODO: Remove this and use SSH keys only in production
    initialPassword = "nixos123";  # Change this on first login!

    # SSH keys will be managed by Terraform/nixos-anywhere
    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key here
      # Or manage via Terraform
    ];
  };

  # System packages (minimal - this is a server)
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    btop
    ncdu       # Disk usage analyzer
    tree
    tmux

    # Database tools
    postgresql
    redis

    # Backup tools (from backup.nix)
    borgbackup
  ];

  # Enable zsh for root
  programs.zsh.enable = true;
  users.users.root.shell = pkgs.zsh;

  # Allow unfree packages (if needed)
  nixpkgs.config.allowUnfree = true;

  # System state version (NixOS 25.05)
  system.stateVersion = "25.05";

  # Notes:
  # - All service data stored in /data/* (PostgreSQL, Redis, Gitea)
  # - Backups configured via backup.nix to backup /data
  # - Services accessible from K3s cluster via static IP (192.168.1.11)
  # - Gitea includes container registry for K3s images
}
