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
    tree

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

    # Task & project management
    jiratui           # TUI for Atlassian Jira
    todoist           # CLI for Todoist

    # Productivity & utilities
    tealdeer          # Fast tldr client (Rust implementation)
    navi              # Interactive cheatsheet tool
    hygg              # Fast grep with gitignore support
    posting           # HTTP client TUI (Postman alternative)
    oxker             # Docker container manager TUI

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

    name: Workstation
    root: ~/code/nix-cfg


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

      - claude:
          # You can specify layout (even, main-vertical, main-horizontal, tiled)
          layout: even-horizontal
          panes:
            - claude

      - terminal:
          panes:
            - #

      - email:
          panes:
            - neomutt
  '';

  # JiraTUI configuration template
  # Copy ~/.config/jiratui/config.yaml.template to config.yaml and fill in your credentials
  xdg.configFile."jiratui/config.yaml.template".text = ''
    # JiraTUI Configuration
    # Copy this file to config.yaml and fill in your actual values
    # See: https://jiratui.readthedocs.io/en/latest/users/configuration/

    # ===== REQUIRED SETTINGS =====
    # You MUST fill these in for jiratui to work

    # Your Jira email address
    jira_api_username: 'your.email@company.com'

    # Your Jira API token
    # Generate at: https://id.atlassian.com/manage-profile/security/api-tokens
    jira_api_token: 'your-api-token-here'

    # Your Jira instance URL
    jira_api_base_url: 'https://your-company.atlassian.net'

    # ===== OPTIONAL SETTINGS =====
    # Sensible defaults provided - customize as needed

    # Base URL for building web links (usually same as api_base_url without /rest/api/*)
    jira_base_url: 'https://your-company.atlassian.net'

    # Your Jira account ID (auto-selects you in dropdowns)
    # Find it at: https://your-company.atlassian.net/rest/api/3/myself
    # jira_account_id: 'your-account-id-here'

    # Search & Display Settings
    search_results_per_page: 50
    search_issues_default_day_interval: 30  # Days to search when no criteria given
    show_issue_web_links: true
    search_results_truncate_work_item_summary: 80  # Truncate long summaries
    search_results_style_work_item_status: true
    search_results_style_work_item_type: true
    search_on_startup: false  # Set to true to auto-search on launch

    # Performance
    on_start_up_only_fetch_projects: true  # Faster startup

    # User Interface
    confirm_before_quit: false
    theme: 'dracula'  # Options: textual-dark, textual-light, monokai, dracula, etc.
    tui_title_include_jira_server_title: true

    # Filtering
    search_results_page_filtering_enabled: true
    search_results_page_filtering_minimum_term_length: 3
    full_text_search_minimum_term_length: 3
    enable_advanced_full_text_search: true

    # Authentication
    cloud: true  # Set to false if using Jira Data Center (on-premise)
    use_bearer_authentication: false  # Most users should keep this false

    # Logging (useful for debugging)
    # log_file: '~/.local/share/jiratui/jiratui.log'
    # log_level: 'INFO'  # Options: DEBUG, INFO, WARNING, ERROR

    # Predefined JQL queries (customize for your workflow)
    # pre_defined_jql_expressions:
    #   1:
    #     name: "My Open Issues"
    #     expression: "assignee = currentUser() AND status != Done ORDER BY updated DESC"
    #   2:
    #     name: "Recent Updates"
    #     expression: "updated >= -7d ORDER BY updated DESC"
    #   3:
    #     name: "In Progress"
    #     expression: "assignee = currentUser() AND status = 'In Progress' ORDER BY priority DESC"

    # Default JQL expression to use on work items search (use ID from above)
    # jql_expression_id_for_work_items_search: 1
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
