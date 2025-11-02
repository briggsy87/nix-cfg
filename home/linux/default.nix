{ config, pkgs, lib, ... }:

{
  imports = [
    ./hyprland
    ./waybar
    ./rofi
    ./gtk
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    # Terminal
    alacritty

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
    "tmux/tmux.conf".source = ../tmux/tmux.conf;
  };
}
