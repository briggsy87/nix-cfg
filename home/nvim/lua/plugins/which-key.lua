return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },
    win = {
      border = 'rounded',
      padding = { 2, 2, 2, 2 },
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)

    -- Register group names
    wk.add({
      { '<leader>f', group = 'Find' },
      { '<leader>g', group = 'Git' },
      { '<leader>h', group = 'Hunk' },
      { '<leader>b', group = 'Buffer' },
      { '<leader>c', group = 'Code' },
      { '<leader>r', group = 'Rename' },
    })
  end,
}
