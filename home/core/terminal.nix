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

    # TUI applications
    yazi          # File manager
    ranger        # File manager
    nnn           # File manager
    broot         # Tree navigator
    btop          # System monitor
    glow          # Markdown renderer
    lazydocker    # Docker TUI

    # Image preview support for ranger
    chafa         # Image to ANSI art converter (best for Wayland terminals)
    ueberzugpp    # Image overlay for terminals (better quality)

    # Crypto & secrets
    gnupg
    age
    sops

    # Containers & Kubernetes
    kubectl
    kubectx
    k9s
    helm
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
}
