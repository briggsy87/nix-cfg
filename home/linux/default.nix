{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland
    ./waybar
    ./rofi
    ./gtk
    ./mako
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    # Terminals
    alacritty
    ghostty

    # Terminal multiplexer
    tmux

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
    "tmux/tmux.conf".source = ../tmux/tmux.conf;
    "ranger/rc.conf".text = builtins.readFile ../ranger/rc.conf;
  };
}
