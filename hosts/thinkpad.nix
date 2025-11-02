{ config, pkgs, hostname, username, ... }:

{
  imports = [
    # Include the hardware scan results
    ./thinkpad-hardware.nix
  ];

  # Nix configuration
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Use latest kernel (matching your working config)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Locale & timezone (matching your working config)
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Hyprland Wayland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # SDDM display manager for Hyprland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Enable X11 for XWayland support
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable sound with PipeWire (matching your working config)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel" # sudo
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Enable Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git

    # Hyprland essentials
    kitty              # Default terminal
    firefox            # Browser
    networkmanagerapplet  # Network manager tray

    # Wayland utilities
    wayland
    xwayland
  ];

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server
  };

  # Enable 32-bit libraries for Steam and gaming
  hardware.graphics.enable32Bit = true;

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Enable polkit (required for Hyprland)
  security.polkit.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    montserrat
  ];

  # SSH daemon (optional - uncomment if needed)
  # services.openssh.enable = true;

  # Firewall (optional - configure as needed)
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.enable = false;

  # This value determines the NixOS release compatibility
  # Match your current system version
  system.stateVersion = "25.05"; # Did you read the comment?
}
