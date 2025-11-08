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
    # gitui  # Temporarily disabled - build fails on ARM macOS
    delta

    # TUI & workflow
    yazi
    ranger
    nnn
    broot
    btop
    glow
    lazydocker
    #spotify-player  # Spotify TUI client

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
    wally-cli
  ];

  # bat (cat with syntax highlighting) - Dracula theme
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers,changes,header";
    };
  };

  # spotify-player configuration
  xdg.configFile."spotify-player/app.toml" = {
    source = ./spotify-player/app.toml;
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # Disable default config to avoid future deprecation warnings
    matchBlocks = {
      # Default settings for all hosts
      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 3;
        compression = true;
      };

      # Work GitHub (using w.github.com alias)
      "work" = {
        host = "w.github.com";
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      # Personal GitHub (using p.github.com alias)
      "personal" = {
        host = "p.github.com";
        hostname = "github.com";
        identityFile = "~/.ssh/personal_git";
        identitiesOnly = true;
      };
    };
  };
}
