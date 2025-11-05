{ config, pkgs, lib, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # Window management & input
    aerospace
    karabiner-elements

    # Terminals
    #ghostty
    alacritty

    # Terminal multiplexers
    # Note: tmux configured via programs.tmux in home/core/tmux.nix
    zellij

    # macOS-specific container runtime
    colima
  ];

  # macOS dotfiles
  xdg.configFile = {
    "aerospace/aerospace.toml" = {
      text = builtins.readFile ../aerospace.toml;
      force = true;  # Allow overwriting existing file
    };
    "karabiner/karabiner.json" = {
      text = builtins.readFile ../karabiner.json;
      force = true;
    };
    "ghostty/config" = {
      text = builtins.readFile ../ghostty/config;
      force = true;
    };
    "alacritty/alacritty.toml" = {
      text = builtins.readFile ../alacritty.toml;
      force = true;
    };
    # Note: tmux.conf managed by programs.tmux in home/core/tmux.nix
    "zellij/config.kdl" = {
      source = ../zellij/config.kdl;
      force = true;
    };
  };
}
