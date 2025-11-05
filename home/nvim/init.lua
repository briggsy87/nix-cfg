-- Leader key (set before loading plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Load plugin configurations
-- Plugins are installed via Nix, we just configure them here
require('plugins.colorscheme')
require('plugins.lualine')
require('plugins.telescope')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.none-ls')
require('plugins.completion')
require('plugins.oil')
require('plugins.neotree')
require('plugins.git')
require('plugins.which-key')

-- Editing enhancements
require('plugins.undotree')
require('plugins.vim-tmux-navigator')
-- Note: vim-commentary and vim-surround work out of box, no config needed

-- Testing & tmux integration
require('plugins.vimux')
require('plugins.vim-test')
