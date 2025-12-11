-- markdown-preview.nvim configuration
-- Preview markdown files in browser

-- Settings
vim.g.mkdp_auto_start = 0  -- Don't auto-start preview when opening markdown
vim.g.mkdp_auto_close = 1  -- Auto-close preview when changing buffer
vim.g.mkdp_refresh_slow = 0  -- Refresh on change (not just on save)
vim.g.mkdp_command_for_global = 0  -- Only available for markdown files
vim.g.mkdp_open_to_the_world = 0  -- Don't make server accessible from network
vim.g.mkdp_open_ip = '127.0.0.1'
vim.g.mkdp_port = '8765'
vim.g.mkdp_browser = ''  -- Use default browser

-- Preview theme (github or dark)
vim.g.mkdp_theme = 'dark'  -- Matches Dracula aesthetic

-- Page title
vim.g.mkdp_page_title = '${name}'  -- Use filename as title

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Markdown preview commands
keymap('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', vim.tbl_extend('force', opts, { desc = 'Markdown preview start' }))
keymap('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', vim.tbl_extend('force', opts, { desc = 'Markdown preview stop' }))
keymap('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', vim.tbl_extend('force', opts, { desc = 'Markdown preview toggle' }))
