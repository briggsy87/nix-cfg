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

-- Auto-resolve symlinks with visual indicator
-- This ensures all symlinks to the same file open the same buffer,
-- while showing you when a file was accessed via symlink
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local bufpath = vim.api.nvim_buf_get_name(args.buf)

    -- Skip if buffer is empty or special
    if bufpath == '' or vim.bo[args.buf].buftype ~= '' then
      return
    end

    -- Check if path is a symlink and resolve it
    local realpath = vim.fn.resolve(bufpath)

    -- If it's a symlink (resolved path differs), switch to real file
    if realpath ~= bufpath and vim.fn.filereadable(realpath) == 1 then
      -- Store the symlink path for reference
      local symlink_path = bufpath

      -- Change buffer name to the real path (keeps same buffer, changes path)
      vim.api.nvim_buf_set_name(args.buf, realpath)

      -- Force reload the buffer content from the real file
      vim.cmd('silent! edit!')

      -- Store symlink info in buffer variable
      vim.b[args.buf].is_symlink_target = true
      vim.b[args.buf].symlink_path = symlink_path

      -- Show subtle notification (single line, no Press ENTER prompt)
      vim.notify(
        string.format('🔗 %s → %s',
          vim.fn.fnamemodify(symlink_path, ':~:.'),
          vim.fn.fnamemodify(realpath, ':~:.')
        ),
        vim.log.levels.INFO
      )

      -- Add a namespace for our symlink indicators
      local ns = vim.api.nvim_create_namespace('symlink_indicator')

      -- Add extmark at top of file as visual indicator
      vim.api.nvim_buf_set_extmark(args.buf, ns, 0, 0, {
        virt_text = {{ '🔗 symlink', 'Comment' }},
        virt_text_pos = 'right_align',
      })
    end
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
