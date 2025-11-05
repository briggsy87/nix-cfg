-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- Import all plugin specs from lua/plugins/*.lua
    { import = 'plugins' },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = {
    -- Don't install missing plugins on startup (we use Nix)
    missing = false,
    colorscheme = { 'dracula' },
  },
  checker = {
    enabled = false, -- Don't check for updates (managed by Nix)
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    border = 'rounded',
  },
})
