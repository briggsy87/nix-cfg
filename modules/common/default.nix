# Common configuration for all NixOS hosts
# Includes packages and settings shared between servers and desktops

{ config, pkgs, lib, ... }:

{
  # Common system packages for all hosts
  environment.systemPackages = with pkgs; [
    # Editors
    vim

    # Network tools
    wget
    curl

    # Version control
    git

    # System monitoring
    htop

    # Secrets management (for sops-nix)
    age
    sops
  ];

  # Nix settings (standard across all hosts)
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Allow unfree packages system-wide
  nixpkgs.config.allowUnfree = true;
}
