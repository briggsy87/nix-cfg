{ config, pkgs, hostname, username, ... }:

{
  # Nix features
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    warn-dirty = false;
  };


  # TouchID for sudo
  security.pam.enableSudoTouchIdAuth = true;

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

  # Services you might want later (kept minimal)
  # services.yabai.enable = false; # not needed with Aerospace; keeping SIP intact

  # Homebrew not required; Nix provides everything
  homebrew.enable = false;

  # System hostname
  networking.hostName = hostname;
  networking.computerName = hostname;
}