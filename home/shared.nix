{ config, pkgs, lib, ... }:

{
  # Enable font management
  fonts.fontconfig.enable = true;

  # Cross-platform packages
  home.packages = with pkgs; [
    # AI assistants
    # Note: Claude Code installation:
    # 1. curl -fsSL https://anthropic.sh | sh
    # 2. Restart your terminal (or run: exec zsh)
    # 3. claude auth login
    # (The installer adds ~/.local/bin to PATH, which home-manager handles)

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

      # Ensure ~/.local/bin is in PATH for Claude Code
      export PATH="$HOME/.local/bin:$PATH"
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

  # Additional shell configurations
  programs.bash = {
    enable = true;
    initExtra = ''
      # Source zsh if available and not already in zsh
      if [ -z "$ZSH_VERSION" ] && command -v zsh &> /dev/null; then
        export SHELL=$(command -v zsh)
        exec zsh
      fi
    '';
  };
}
