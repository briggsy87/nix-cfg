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

    # Tmux session management
    sesh              # Modern tmux session manager (Rust, fast, tmuxinator-aware)
    tmuxinator        # Declarative tmux session templates

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

  # sesh configuration (tmux session manager)
  xdg.configFile."sesh/sesh.toml".text = ''
    # Default session name when creating new sessions
    default_session_name = "main"

    # Startup script to run when creating a new session (optional)
    # startup_script = "~/.config/sesh/startup.sh"

    # Session search paths - sesh will look for projects in these directories
    # It searches one level deep by default
    [[session_configs]]
    name = "code"
    path = "~/code"
    search_depth = 2

    [[session_configs]]
    name = "projects"
    path = "~/projects"
    search_depth = 2

    [[session_configs]]
    name = "work"
    path = "~/work"
    search_depth = 2
  '';

  # Tmuxinator example configuration
  # Create your own in ~/.config/tmuxinator/
  # Start with: tmuxinator start example (or just: mux example)
  xdg.configFile."tmuxinator/example.yml".text = ''
    # Example tmuxinator configuration
    # Copy this file and customize for your projects
    # Usage: tmuxinator start example
    # Or create alias: alias mux='tmuxinator start'

    name: example
    root: ~/code

    # Optional: Run on project start, always
    # on_project_start: npm install

    # Optional: Run on project stop
    # on_project_stop: docker-compose down

    # Runs before everything. Use it to start daemons etc.
    # pre: docker-compose up -d

    # Runs after everything. Use it to attach to session
    # post: tmux select-window -t 1

    # Project startup windows
    windows:
      - editor:
          layout: main-vertical
          panes:
            - nvim
            - # empty pane for terminal commands

      - server:
          # You can specify layout (even, main-vertical, main-horizontal, tiled)
          layout: even-horizontal
          panes:
            - npm run dev
            - # logs or secondary process

      - git:
          panes:
            - lazygit

      - docker:
          panes:
            - lazydocker
  '';

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
