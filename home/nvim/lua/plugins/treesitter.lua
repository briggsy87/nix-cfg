-- Treesitter configuration
require('nvim-treesitter.configs').setup({
  -- Don't auto-install parsers (managed by Nix)
  auto_install = false,
  -- Use a writable directory for compiled parsers
  parser_install_dir = vim.fn.stdpath('data') .. '/treesitter',
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = false,
      node_decremental = '<bs>',
    },
  },
})

-- Add parser directory to runtimepath
vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/treesitter')
