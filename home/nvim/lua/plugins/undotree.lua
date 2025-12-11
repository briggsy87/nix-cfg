-- Undotree configuration (undo history visualizer)

-- Undotree settings
vim.g.undotree_WindowLayout = 2        -- Layout style
vim.g.undotree_ShortIndicators = 1     -- Use short time indicators
vim.g.undotree_SetFocusWhenToggle = 1  -- Focus undotree when toggled

-- Keymaps
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle Undotree' })
