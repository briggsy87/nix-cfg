{ config, pkgs, lib, ... }:

{
  # Enable font management
  fonts.fontconfig.enable = true;

  # Cross-platform packages
  home.packages = with pkgs; [
    # AI assistants
    # Note: Install Claude Code via: curl -fsSL https://anthropic.sh | sh
    # Then authenticate with: claude auth login
    # (Not available in nixpkgs yet, use installer script)

    # Terminal & editing
    ripgrep
    fd
    fzf
    eza
    zoxide
    jq
    yq-go
    tldr

    # Git tools
    git
    git-lfs
    lazygit
    gitui
    delta

    # TUI & workflow
    yazi
    ranger
    nnn
    broot
    btop
    glow
    lazydocker

    # Crypto & secrets
    gnupg
    age
    sops

    # Containers & k8s
    kubectl
    kubectx
    k9s
    stern

    # Languages / tooling
    nodejs_22
    python313
    terraform
    tflint

    # LSP/formatters/linters (use Nix, skip Mason)
    pyright
    ruff
    black
    isort
    typescript-language-server
    vscode-langservers-extracted # eslint/tsserver/html/css/json
    prettier
    terraform-ls
    bash-language-server
    yaml-language-server
    dockerfile-language-server
    lua-language-server
    stylua
    shfmt

    # Fonts
    #(nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    
    claude-code
  ];

  # bat (cat with syntax highlighting) - Dracula theme
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes,header";
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "work" = {
        host = "w.github.com-w";
        hostname = "github.com";
        identityFile = "~/.ssh/id_rsa";
        identitiesOnly = true;
      };
      "personal" = {
        host = "p.github.com";
        hostname = "github.com";
        identityFile = "~/.ssh/personal_git";
        identitiesOnly = true;
      };
    };
  };
}
