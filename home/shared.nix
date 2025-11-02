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
    bat
    eza
    zoxide
    jq
    yq-go

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
    helm
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

  # Shell configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(starship init zsh)"
      export EDITOR=nvim
    '';
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      # Essentials
      plenary-nvim
      telescope-nvim
      nvim-treesitter
      nvim-lspconfig
      null-ls-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      friendly-snippets
      gitsigns-nvim
      lazygit-nvim
      oil-nvim # minimal file manager in-buffer
      which-key-nvim
    ];
    extraLuaConfig = builtins.readFile ./nvim/init.lua;
  };

  # Starship prompt
  programs.starship.enable = true;

  # Direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
	user.name = "Kyle Briggs";
	user.email = "briggsy87@gmail.com";
	init.defaultBranch = "main";
        pull.rebase = true;
	};
    #delta.enable = true;
    #extraConfig = {
    #  init.defaultBranch = "main";
    #  pull.rebase = true;
    #};
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # Neovim config file (shared across platforms)
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./nvim/init.lua;
}
