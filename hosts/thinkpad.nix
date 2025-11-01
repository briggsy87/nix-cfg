{ config, pkgs, hostname, username, ... }:

{
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

  # Networking
  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # Locale & timezone
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console settings
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # X11 / Desktop environment
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true; # Minimal DE - can switch to i3/Hyprland later

    # Keyboard layout
    xkb = {
      layout = "us";
      options = "caps:escape"; # Caps Lock = Escape
    };
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # User account
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # sudo
      "networkmanager"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # SSH daemon
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
  };

  # This value determines the NixOS release compatibility
  system.stateVersion = "24.05"; # Don't change without reading release notes
}
