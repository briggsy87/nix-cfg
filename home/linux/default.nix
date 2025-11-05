{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland
    ./waybar
    ./rofi
    ./gtk
    ./mako
    ./hyprlock
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    # Terminals
    alacritty
    ghostty

    # Terminal multiplexer
    # Note: tmux configured via programs.tmux in home/core/tmux.nix

    # Linux-specific container runtime
    docker-compose

    # System utilities
    htop
    pciutils
    usbutils

    # Development
    vscode

    # Gaming
    steam

    # Additional Wayland tools
    wl-clipboard
    xdg-utils
  ];

  # Linux dotfiles
  xdg.configFile = {
    "alacritty/alacritty.toml".text = builtins.readFile ../alacritty.toml;
    "ghostty/config".text = builtins.readFile ../ghostty/config-linux;
    "kitty/kitty.conf".text = builtins.readFile ../kitty.conf;
    # Note: tmux.conf managed by programs.tmux in home/core/tmux.nix
    "ranger/rc.conf".text = builtins.readFile ../ranger/rc.conf;
  };

  # Install power menu script
  home.file.".local/bin/power-menu" = {
    source = ./scripts/power-menu.sh;
    executable = true;
  };
}
