-- Vimux configuration (tmux integration)
-- Allows running commands in a tmux pane from vim

-- Vimux settings
vim.g.VimuxHeight = '30'        -- Height of tmux pane (percentage)
vim.g.VimuxOrientation = 'v'    -- Split vertically (left/right)
vim.g.VimuxUseNearest = 1       -- Use nearest pane instead of creating new one

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Vimux commands
keymap('n', '<leader>vp', '<cmd>VimuxPromptCommand<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux prompt command' }))
keymap('n', '<leader>vl', '<cmd>VimuxRunLastCommand<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux run last command' }))
keymap('n', '<leader>vi', '<cmd>VimuxInspectRunner<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux inspect runner' }))
keymap('n', '<leader>vz', '<cmd>VimuxZoomRunner<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux zoom runner' }))
keymap('n', '<leader>vq', '<cmd>VimuxCloseRunner<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux close runner' }))
keymap('n', '<leader>vc', '<cmd>VimuxInterruptRunner<CR>', vim.tbl_extend('force', opts, { desc = 'Vimux interrupt runner' }))
