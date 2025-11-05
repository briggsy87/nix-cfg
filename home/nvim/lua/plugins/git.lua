-- Git integration (gitsigns + lazygit)

-- GitSigns configuration
require('gitsigns').setup({
  signs = {
    add = { text = '│' },
    change = { text = '│' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, 'Next git hunk')

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, 'Previous git hunk')

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
    map('v', '<leader>hs', function()
      gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Stage hunk')
    map('v', '<leader>hr', function()
      gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Reset hunk')
    map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
    map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
    map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end, 'Blame line')
    map('n', '<leader>hd', gs.diffthis, 'Diff this')
    map('n', '<leader>hD', function()
      gs.diffthis('~')
    end, 'Diff this ~')

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns select hunk')
  end,
})

-- LazyGit keymap
vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
