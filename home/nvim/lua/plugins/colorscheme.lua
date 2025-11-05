return {
  -- Dracula theme (active)
  {
    'Mofiqul/dracula.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('dracula').setup({
        transparent_bg = true,
        colors = {
          bg = 'none',
          bgdark = 'none',
        },
      })
      vim.cmd('colorscheme dracula')
    end,
  },

  -- Alternative themes (uncomment to use)
  {
    'folke/tokyonight.nvim',
    enabled = false, -- Set to true to enable
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'moon',
        transparent = true,
      })
      -- vim.cmd('colorscheme tokyonight-moon')
    end,
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    enabled = false, -- Set to true to enable
    lazy = false,
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        transparent_background = true,
      })
      -- vim.cmd('colorscheme catppuccin-mocha')
    end,
  },

  {
    'EdenEast/nightfox.nvim',
    enabled = false, -- Set to true to enable
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd('colorscheme carbonfox')
    end,
  },

  {
    'rebelot/kanagawa.nvim',
    enabled = false, -- Set to true to enable
    lazy = false,
    priority = 1000,
    config = function()
      -- vim.cmd('colorscheme kanagawa')
    end,
  },
}
