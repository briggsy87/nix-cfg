-- vim-visual-multi configuration (multiple cursors)
-- Works out of box with default keybindings

-- Main keybindings (default):
-- C-n         : Start multi-cursor, select next occurrence
-- C-Down/Up   : Create cursor above/below
-- n/N         : Get next/previous occurrence
-- q           : Skip current and get next occurrence
-- Q           : Remove current cursor/selection
-- [/]         : Select next/previous cursor
-- Tab         : Switch between cursor and extend mode
-- <Esc>       : Exit multi-cursor mode

-- Additional settings
vim.g.VM_theme = 'purplegray'  -- Theme (matches Dracula aesthetic)
vim.g.VM_highlight_matches = 'underline'
vim.g.VM_silent_exit = 1  -- Don't show message when exiting

-- Custom mappings (optional - uncomment if you want different keys)
-- vim.g.VM_maps = {
--   ['Find Under'] = '<C-d>',  -- Change from C-n to C-d
--   ['Find Subword Under'] = '<C-d>',
-- }
