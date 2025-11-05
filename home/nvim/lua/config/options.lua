-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic editor settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Size of indent
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.smartindent = true    -- Insert indents automatically
vim.opt.wrap = false          -- Disable line wrap
vim.opt.termguicolors = true  -- True color support

-- Search
vim.opt.ignorecase = true     -- Ignore case in search
vim.opt.smartcase = true      -- Unless uppercase is used

-- UI
vim.opt.signcolumn = 'yes'    -- Always show sign column
vim.opt.cursorline = true     -- Highlight current line
vim.opt.scrolloff = 8         -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8     -- Keep 8 columns left/right of cursor

-- Splits
vim.opt.splitright = true     -- New vertical splits go right
vim.opt.splitbelow = true     -- New horizontal splits go below

-- Behavior
vim.opt.mouse = 'a'           -- Enable mouse
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.undofile = true       -- Persistent undo
vim.opt.updatetime = 250      -- Faster completion
vim.opt.timeoutlen = 300      -- Faster key sequence timeout
