{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Core utilities
    ripgrep
    fd
    fzf
    bat
    eza
    jq
    yq-go

    # Archive tools (for yazi and file managers)
    p7zip         # 7zip support
    unzip         # ZIP archives
    unrar         # RAR archives

    # TUI applications
    ranger        # File manager
    nnn           # File manager
    broot         # Tree navigator
    btop          # System monitor
    glow          # Markdown renderer
    lazydocker    # Docker TUI

    # Image preview support for ranger/nnn
    chafa         # Image to ANSI art converter (best for Wayland terminals)
    ueberzugpp    # Image overlay for terminals (better quality)
    imagemagick   # Image processing (needed by ranger for previews)
    libsixel      # Sixel graphics support
    file          # File type detection (needed for previews)
    highlight     # Syntax highlighting for text previews

    # Kitty terminal - has excellent image preview support
    kitty

    # Crypto & secrets
    gnupg
    age
    sops

    # Containers & Kubernetes
    kubectl
    kubectx
    k9s
    kubernetes-helm
    stern
  ];

  # Bat - cat with syntax highlighting (themed by Stylix)
  programs.bat = {
    enable = true;
  };

  # Eza - modern ls replacement
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  # FZF - fuzzy finder (themed by Stylix)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Yazi - file manager with Dracula theme
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../yazi/yazi.toml);
    theme = builtins.fromTOML (builtins.readFile ../yazi/theme.toml);
    initLua = builtins.readFile ../yazi/init.lua;
  };
}
