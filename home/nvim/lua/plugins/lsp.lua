return {
  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Get capabilities for completion
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
    end,
  },
}
