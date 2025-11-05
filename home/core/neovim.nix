{ config, pkgs, lib, ... }:

{
  # Neovim configuration with lazy.nvim and modular setup
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      # Essentials (all installed via Nix for reproducibility)
      plenary-nvim
      telescope-nvim
      telescope-ui-select-nvim
      nvim-treesitter
      none-ls-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      gitsigns-nvim
      lazygit-nvim
      oil-nvim
      neo-tree-nvim
      which-key-nvim
      nvim-web-devicons
      lualine-nvim
      nui-nvim  # Required by neo-tree

      # Colorschemes (dark/purple themes)
      dracula-nvim
      tokyonight-nvim
      catppuccin-nvim
      nightfox-nvim
      kanagawa-nvim
    ];
  };

  # Copy entire nvim directory structure (init.lua + lua/ directory)
  xdg.configFile = {
    "nvim/init.lua".source = ../nvim/init.lua;
    "nvim/lua" = {
      source = ../nvim/lua;
      recursive = true;
    };
  };
}
