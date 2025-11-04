{ config, pkgs, lib, hostname, username, ... }:

{

  # Nix features
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };

  nix.optimise.automatic = true;

  users.users.${username} = {
    home = "/Users/${username}";
  };

  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System defaults to reduce friction
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false; # hold for key repeat
      InitialKeyRepeat = 15;
      KeyRepeat = 2; # faster repeat
    };
    dock = {
      autohide = true;
      mru-spaces = false; # keep workspace order stable
      tilesize = 36;
      show-recents = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      ShowStatusBar = true;
      ShowPathbar = true;
    };
  };

  # Login shell
  programs.zsh.enable = true;

  # Homebrew configuration via nix-homebrew
  nix-homebrew = {
    enable = true;
    enableRosetta = true; # For x86_64 apps on Apple Silicon
    user = username;
    autoMigrate = true; # Automatically migrate existing Homebrew installations
  };

  # Declarative Homebrew packages/casks
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap"; # Uninstall packages not declared here
      autoUpdate = true;
      upgrade = true;
    };

    # Casks for GUI apps not available or broken in nixpkgs
    casks = [
      "ghostty"   # Terminal - not available for darwin in nixpkgs
      "raycast"   # Launcher - better than Spotlight for finding Nix apps
      "arc"       # Browser - workspace 1
      "cursor"    # AI IDE - workspace 4
    ];

    # Brews (CLI tools) - prefer nixpkgs when possible
    brews = [
      # Add any CLI tools here that aren't available in nixpkgs
    ];
  };

  # Ensure Spotlight indexes Home Manager apps
  # Note: Home Manager already creates ~/Applications/Home Manager Apps/
  # We just need to ensure Spotlight sees it
  system.activationScripts.applications.text = lib.mkForce ''
    user_home="/Users/${username}"
    hm_apps="$user_home/Applications/Home Manager Apps"

    if [ -d "$hm_apps" ]; then
      echo "Requesting Spotlight index for Nix apps..." >&2
      sudo -u ${username} mdimport "$hm_apps" 2>/dev/null || true
      echo "✓ Nix apps are at: $hm_apps" >&2
      echo "  If Spotlight doesn't find them, run: ./FIX-SPOTLIGHT.sh" >&2
    fi
  '';

  # System hostname
  networking.hostName = hostname;
  networking.computerName = hostname;

  system.stateVersion = 6;
  system.primaryUser = username;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}