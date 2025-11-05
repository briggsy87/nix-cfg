-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Enable transparency to match terminal
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = function()
    -- Make background transparent
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })

    -- Make line numbers transparent
    vim.api.nvim_set_hl(0, 'LineNr', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'Folded', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'SpecialKey', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = 'none' })
  end,
})

-- Apply transparency immediately after loading
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'help',
    'lspinfo',
    'man',
    'qf',
    'query',
    'startuptime',
    'checkhealth',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- LSP keybindings (set up on LspAttach event)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local buf = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    buf('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    buf('n', 'gr', vim.lsp.buf.references, 'Go to references')
    buf('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    buf('n', 'gI', vim.lsp.buf.implementation, 'Go to implementation')
    buf('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
    buf('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
    buf('n', 'gK', vim.lsp.buf.signature_help, 'Signature help')
    buf('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    buf('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    buf('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    buf('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
    buf('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')
  end,
})
