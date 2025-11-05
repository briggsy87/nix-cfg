-- Colorscheme configuration
-- Setup Dracula theme
require('dracula').setup({
  transparent_bg = true,
  colors = {
    bg = 'none',
    bgdark = 'none',
  },
})

-- Load colorscheme
vim.cmd('colorscheme dracula')

-- Alternative colorschemes (comment out dracula above and uncomment one below to switch):
-- require('tokyonight').setup({ style = 'moon', transparent = true })
-- vim.cmd('colorscheme tokyonight-moon')

-- require('catppuccin').setup({ flavour = 'mocha', transparent_background = true })
-- vim.cmd('colorscheme catppuccin-mocha')

-- vim.cmd('colorscheme carbonfox')
-- vim.cmd('colorscheme kanagawa')
