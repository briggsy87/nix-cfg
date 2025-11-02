{ config, pkgs, lib, ... }:

{
  # macOS-specific packages
  home.packages = with pkgs; [
    # Window management & input
    aerospace
    karabiner-elements

    # Terminals
    ghostty
    alacritty

    # Terminal multiplexers
    tmux
    zellij

    # macOS-specific container runtime
    colima
  ];

  # macOS dotfiles
  xdg.configFile = {
    "aerospace/aerospace.toml".text = builtins.readFile ../aerospace.toml;
    "karabiner/karabiner.json".text = builtins.readFile ../karabiner.json;
    "ghostty/config".text = builtins.readFile ../ghostty/config;
    "alacritty/alacritty.toml".text = builtins.readFile ../alacritty.toml;
    "tmux/tmux.conf".source = ../tmux/tmux.conf;
    "zellij/config.kdl".source = ../zellij/config.kdl;
  };
}
