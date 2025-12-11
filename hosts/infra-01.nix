{ config, pkgs, hostname, username, ... }:

{
  imports = [
    # Hardware configuration will be added by nixos-anywhere
    # It will create infra-01-hardware.nix automatically

    # Import service modules
    ../modules/services/postgresql.nix
    ../modules/services/redis.nix
    ../modules/services/gitea.nix
    ../modules/services/backup.nix
  ];

  # Nix settings (standard across all hosts)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking = {
    hostName = hostname;
    networkmanager.enable = true;

    # Static IP is configured by Proxmox/Terraform via cloud-init
    # No need to set it here

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

  # Mount /data disk (second disk from Terraform)
  # This will be /dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1
  fileSystems."/data" = {
    device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi1";
    fsType = "ext4";
    autoFormat = true; # NixOS will format on first boot if not formatted
  };

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
