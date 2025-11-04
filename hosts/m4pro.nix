{ config, pkgs, lib, hostname, username, ... }:

{
  # System-level packages (alternative to home-manager for GUI apps)
  # Uncomment to test if GUI apps work better at system level vs home-manager
  # environment.systemPackages = with pkgs; [
  #   ghostty
  #   gitui
  # ];

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
      "ghostty" # Not available for darwin in nixpkgs
    ];

    # Brews (CLI tools) - prefer nixpkgs when possible
    brews = [
      # Add any CLI tools here that aren't available in nixpkgs
    ];
  };

  # Link Nix apps to ~/Applications for Spotlight indexing
  # Alternative to mac-app-util until upstream is fixed
  system.activationScripts.applications.text = lib.mkForce ''
    echo "Setting up ~/Applications/Nix Apps..." >&2
    app_folder="$HOME/Applications/Nix Apps"
    mkdir -p "$app_folder"

    # Remove broken symlinks
    find "$app_folder" -type l ! -exec test -e {} \; -delete

    # Create symlinks for all .app bundles in /Applications
    for app in $(find /Applications -maxdepth 1 -type d -name "*.app" 2>/dev/null); do
      app_name=$(basename "$app")
      if [ ! -e "$app_folder/$app_name" ]; then
        ln -sf "$app" "$app_folder/$app_name"
      fi
    done
  '';

  # System hostname
  networking.hostName = hostname;
  networking.computerName = hostname;

  system.stateVersion = 6;
  system.primaryUser = username;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}