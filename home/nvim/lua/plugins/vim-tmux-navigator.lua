-- vim-tmux-navigator configuration
-- Seamless navigation between vim splits and tmux panes

-- Settings
vim.g.tmux_navigator_no_mappings = 0       -- Use default mappings (Ctrl-hjkl)
vim.g.tmux_navigator_save_on_switch = 2    -- Auto-save on switch (2 = write all buffers)
vim.g.tmux_navigator_disable_when_zoomed = 1  -- Disable when tmux pane is zoomed

-- Note: Default keybindings are:
-- <C-h> - Navigate left
-- <C-j> - Navigate down
-- <C-k> - Navigate up
-- <C-l> - Navigate right
-- <C-\> - Navigate to previous split

-- These will work seamlessly between vim splits and tmux panes
-- when tmux is configured with matching keybindings (see tmux.conf)
