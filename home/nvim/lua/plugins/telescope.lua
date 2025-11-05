return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },
  cmd = 'Telescope',
  keys = {
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
    { '<leader>fb', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
    { '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },
    { '<leader>fc', '<cmd>Telescope commands<cr>', desc = 'Commands' },
    { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
  },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
    defaults = {
      prompt_prefix = ' ',
      selection_caret = ' ',
      path_display = { 'truncate' },
      sorting_strategy = 'ascending',
      layout_config = {
        horizontal = {
          prompt_position = 'top',
          preview_width = 0.55,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      mappings = {
        i = {
          ['<C-n>'] = 'move_selection_next',
          ['<C-p>'] = 'move_selection_previous',
          ['<C-j>'] = 'move_selection_next',
          ['<C-k>'] = 'move_selection_previous',
        },
      },
    },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({}),
        },
      },
    })

    -- Load telescope-ui-select extension
    telescope.load_extension('ui-select')
  end,
}
