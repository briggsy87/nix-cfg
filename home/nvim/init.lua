-- Leader


-- Simple key helpers
local map = vim.keymap.set


-- Telescope
map('n', '<leader>ff', require('telescope.builtin').find_files, {desc='Find files'})
map('n', '<leader>fg', require('telescope.builtin').live_grep, {desc='Live grep'})
map('n', '<leader>fb', require('telescope.builtin').buffers, {desc='Buffers'})
map('n', '<leader>fh', require('telescope.builtin').help_tags, {desc='Help'})


-- Treesitter
require('nvim-treesitter.configs').setup{
ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'tsx', 'json', 'yaml', 'terraform', 'markdown', 'bash' },
highlight = { enable = true },
indent = { enable = true }
}


-- LSP (use system servers installed via Nix)
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()


local on_attach = function(_, bufnr)
local buf = function(mode, lhs, rhs) map(mode, lhs, rhs, { buffer = bufnr }) end
buf('n', 'gd', vim.lsp.buf.definition)
buf('n', 'gr', vim.lsp.buf.references)
buf('n', 'K', vim.lsp.buf.hover)
buf('n', '<leader>rn', vim.lsp.buf.rename)
buf('n', '<leader>ca', vim.lsp.buf.code_action)
buf('n', '[d', vim.diagnostic.goto_prev)
buf('n', ']d', vim.diagnostic.goto_next)
buf('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end)
end


lspconfig.pyright.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.tsserver.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.terraformls.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.jsonls.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.yamlls.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.bashls.setup{ capabilities = capabilities, on_attach = on_attach }
lspconfig.dockerls.setup{ capabilities = capabilities, on_attach = on_attach }


-- null-ls (formatting & linting via external tools)
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
on_attach = on_attach,
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