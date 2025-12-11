-- vim-test configuration (test runner)
-- Uses vimux to run tests in tmux pane

-- Test strategy: use vimux (runs in tmux pane)
vim.g['test#strategy'] = 'vimux'

-- Python: Use pytest
vim.g['test#python#runner'] = 'pytest'
vim.g['test#python#pytest#options'] = '-v'

-- JavaScript/TypeScript: Use jest
vim.g['test#javascript#runner'] = 'jest'
vim.g['test#typescript#runner'] = 'jest'
vim.g['test#javascript#jest#options'] = '--verbose'
vim.g['test#typescript#jest#options'] = '--verbose'

-- Keymaps
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Test commands
keymap('n', '<leader>tn', '<cmd>TestNearest<CR>', vim.tbl_extend('force', opts, { desc = 'Test nearest' }))
keymap('n', '<leader>tf', '<cmd>TestFile<CR>', vim.tbl_extend('force', opts, { desc = 'Test file' }))
keymap('n', '<leader>ts', '<cmd>TestSuite<CR>', vim.tbl_extend('force', opts, { desc = 'Test suite' }))
keymap('n', '<leader>tl', '<cmd>TestLast<CR>', vim.tbl_extend('force', opts, { desc = 'Test last' }))
keymap('n', '<leader>tv', '<cmd>TestVisit<CR>', vim.tbl_extend('force', opts, { desc = 'Test visit' }))
