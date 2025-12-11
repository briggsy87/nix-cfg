-- Which-key for keybinding hints
local wk = require('which-key')

wk.setup({
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
})

-- Register group names
wk.add({
  { '<leader>f', group = 'Find' },
  { '<leader>g', group = 'Git' },
  { '<leader>h', group = 'Hunk' },
  { '<leader>b', group = 'Buffer' },
  { '<leader>c', group = 'Code' },
  { '<leader>r', group = 'Rename' },
  { '<leader>e', desc = 'Explorer' },
  { '<leader>u', desc = 'Undotree' },
  { '<leader>t', group = 'Test' },
  { '<leader>v', group = 'Vimux' },
  { '<leader>m', group = 'Markdown' },
})
