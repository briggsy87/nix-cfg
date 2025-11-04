-- Leader key
vim.g.mapleader = ' '

-- Basic editor settings
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Size of indent
vim.opt.tabstop = 2           -- Number of spaces tabs count for
vim.opt.smartindent = true    -- Insert indents automatically
vim.opt.wrap = false          -- Disable line wrap
vim.opt.termguicolors = true  -- True color support

-- Colorscheme setup (Dark/Purple themes)
-- Some themes need setup() called before loading
pcall(function()
  require('tokyonight').setup({ style = 'moon', transparent = true })
end)

pcall(function()
  require('catppuccin').setup({ flavour = 'mocha', transparent_background = true })
end)

-- Try to load preferred colorscheme with fallbacks
local function try_colorscheme(name)
  local ok, _ = pcall(vim.cmd, 'colorscheme ' .. name)
  return ok
end

-- Try colorschemes in order of preference (dark/purple themes)
if not try_colorscheme('tokyonight-moon') then
  if not try_colorscheme('catppuccin-mocha') then
    if not try_colorscheme('kanagawa') then
      if not try_colorscheme('carbonfox') then
        -- Fallback to built-in dark theme
        vim.cmd('colorscheme habamax')
      end
    end
  end
end

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

-- Apply transparency immediately
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- Alternative colorschemes - uncomment ONE of these to override:
-- vim.cmd('colorscheme tokyonight-moon')      -- Dark with purple accents (default if available)
-- vim.cmd('colorscheme catppuccin-mocha')     -- Catppuccin Mocha (purple tones)
-- vim.cmd('colorscheme carbonfox')            -- Nightfox variant with purple
-- vim.cmd('colorscheme kanagawa')             -- Dark theme with subtle purple

-- Simple key helpers
local map = vim.keymap.set


-- Telescope
map('n', '<leader>ff', require('telescope.builtin').find_files, {desc='Find files'})
map('n', '<leader>fg', require('telescope.builtin').live_grep, {desc='Live grep'})
map('n', '<leader>fb', require('telescope.builtin').buffers, {desc='Buffers'})
map('n', '<leader>fh', require('telescope.builtin').help_tags, {desc='Help'})


-- Treesitter
require('nvim-treesitter.configs').setup{
-- Don't auto-install parsers (managed by Nix)
auto_install = false,
-- Use a writable directory for compiled parsers
parser_install_dir = vim.fn.stdpath('data') .. '/treesitter',
highlight = { enable = true },
indent = { enable = true }
}

-- Add parser directory to runtimepath
vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/treesitter')


-- LSP (use system servers installed via Nix)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- LSP keybindings (set up on LspAttach event)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local buf = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    buf('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    buf('n', 'gr', vim.lsp.buf.references, 'Go to references')
    buf('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
    buf('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    buf('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    buf('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    buf('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
    buf('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, 'Format')
  end,
})

-- Configure LSP servers using new Neovim 0.11+ API
local servers = {
  pyright = { filetypes = { 'python' } },
  ts_ls = { filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } },
  terraformls = { filetypes = { 'terraform', 'tf' } },
  jsonls = { filetypes = { 'json' } },
  yamlls = { filetypes = { 'yaml' } },
  bashls = { filetypes = { 'sh', 'bash' } },
  dockerls = { filetypes = { 'dockerfile' } },
}

for server, config in pairs(servers) do
  vim.lsp.config[server] = {
    cmd = { server },
    filetypes = config.filetypes,
    root_dir = vim.fs.root(0, { '.git', '.gitignore' }),
    capabilities = capabilities,
  }
end

-- Enable LSP servers
vim.lsp.enable(vim.tbl_keys(servers))


-- none-ls (formatting & linting via external tools)
local null_ls = require('null-ls')
null_ls.setup({
sources = {
null_ls.builtins.formatting.black,
null_ls.builtins.formatting.isort,
null_ls.builtins.formatting.prettier,
null_ls.builtins.formatting.terraform_fmt,
null_ls.builtins.formatting.shfmt,
null_ls.builtins.formatting.stylua,
null_ls.builtins.diagnostics.ruff,
-- add eslint_d if desired
},
})


-- Completion
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
cmp.setup({
snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
mapping = cmp.mapping.preset.insert({
['<C-Space>'] = cmp.mapping.complete(),
['<CR>'] = cmp.mapping.confirm({ select = true }),
['<Tab>'] = cmp.mapping.select_next_item(),
['<S-Tab>'] = cmp.mapping.select_prev_item(),
}),
sources = cmp.config.sources({
{ name = 'nvim_lsp' }, { name = 'path' }, { name = 'buffer' }, { name = 'luasnip' }
})
})


-- File tree (oil.nvim: edit the filesystem like a buffer)
require('oil').setup({ view_options = { show_hidden = true } })
map('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })


-- Git integrations
map('n', '<leader>gg', '<CMD>LazyGit<CR>', {desc='LazyGit'})
require('gitsigns').setup()