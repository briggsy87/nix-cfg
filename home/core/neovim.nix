{ config, pkgs, lib, ... }:

{
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
      nvim-treesitter.withAllGrammars
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
      oil-nvim       # Minimal file manager in-buffer
      which-key-nvim
    ];
    extraLuaConfig = builtins.readFile ../nvim/init.lua;
  };

  # Neovim config file (shared across platforms)
  xdg.configFile."nvim/init.lua".text = builtins.readFile ../nvim/init.lua;
}
