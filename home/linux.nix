{ config, pkgs, lib, ... }:

{
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
  ];

  # Linux dotfiles
  xdg.configFile = {
    "alacritty/alacritty.toml".text = builtins.readFile ./alacritty.toml;
    "tmux/tmux.conf".source = ./tmux/tmux.conf;
  };

  # TODO: Add Hyprland/Wayland compositor config when ready
}
