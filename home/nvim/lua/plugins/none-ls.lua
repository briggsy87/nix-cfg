-- none-ls (formatters and linters)
local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    -- Note: Ruff diagnostics removed - use ruff_lsp LSP server instead (configured in lsp.lua)

    -- JavaScript/TypeScript
    null_ls.builtins.formatting.prettier,

    -- Terraform
    null_ls.builtins.formatting.terraform_fmt,

    -- Shell
    null_ls.builtins.formatting.shfmt,

    -- Lua
    null_ls.builtins.formatting.stylua,

    -- Uncomment to add more:
    -- null_ls.builtins.diagnostics.eslint_d,
    -- null_ls.builtins.formatting.eslint_d,
  },
  -- Optional: Format on save
  -- on_attach = function(client, bufnr)
  --   if client.supports_method('textDocument/formatting') then
  --     vim.api.nvim_create_autocmd('BufWritePre', {
  --       buffer = bufnr,
  --       callback = function()
  --         vim.lsp.buf.format({ bufnr = bufnr })
  --       end,
  --     })
  --   end
  -- end,
})
