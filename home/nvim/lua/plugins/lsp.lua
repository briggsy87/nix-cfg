-- LSP Configuration using Neovim 0.11+ native API
-- Get capabilities for completion
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configure LSP servers using new Neovim 0.11+ API
local servers = {
  pyright = { filetypes = { 'python' } },
  ruff = { filetypes = { 'python' } }, -- Ruff LSP for linting/diagnostics
  ts_ls = { filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } },
  terraformls = { filetypes = { 'terraform', 'tf' } },
  jsonls = { filetypes = { 'json' } },
  yamlls = { filetypes = { 'yaml' } },
  bashls = { filetypes = { 'sh', 'bash' } },
  dockerls = { filetypes = { 'dockerfile' } },
}

for server, config in pairs(servers) do
  -- Special handling for ruff LSP server
  local cmd = server == 'ruff' and { 'ruff', 'server' } or { server }

  vim.lsp.config[server] = {
    cmd = cmd,
    filetypes = config.filetypes,
    root_dir = vim.fs.root(0, { '.git', '.gitignore' }),
    capabilities = capabilities,
  }
end

-- Enable LSP servers
vim.lsp.enable(vim.tbl_keys(servers))

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- Customize LSP handlers
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
