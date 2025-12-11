-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Note: Window navigation (C-hjkl) handled by vim-tmux-navigator
-- See lua/plugins/vim-tmux-navigator.lua for configuration

-- Resize windows
map('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
map('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Move text up and down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Stay in indent mode
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

-- Better paste (doesn't replace clipboard)
map('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Better up/down with word wrap
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Quick save
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })

-- Quick quit
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

-- Buffer management
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
