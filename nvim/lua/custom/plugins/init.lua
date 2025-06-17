-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'dhruvasagar/vim-zoom',
  keys = {
    { '<C-w>m', '<Plug>(zoom-toggle)', desc = 'Toggle Zoom' },
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = 80,
        open_mapping = [[<C-\>]],
        direction = 'vertical',
        shade_terminals = false,
      }
    end,
  },
  {
    'ojroques/nvim-osc52',
    config = function()
      require('osc52').setup()
      vim.keymap.set('n', '<leader>y', require('osc52').copy_operator, { expr = true })
      vim.keymap.set('x', '<leader>y', require('osc52').copy_visual)
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    keys = {
      { '<leader>e', ':NvimTreeToggle<CR>', desc = 'Toggle nvim-tree' },
    },
    config = function()
      require('nvim-tree').setup {
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'
          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          -- Navigation
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
          vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
          vim.keymap.set('n', 'v', api.node.open.vertical, opts 'Open: Vertical Split')
          vim.keymap.set('n', 's', api.node.open.horizontal, opts 'Open: Horizontal Split')
          vim.keymap.set('n', 't', api.node.open.tab, opts 'Open: New Tab')
          -- File operations
          vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
          vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
          vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
          vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
          vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy')
          vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
          -- Tree operations
          vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
          vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts 'Toggle Hidden')
          vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Git Ignore')
          -- Close tree
          vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
        end,
      }
    end,
  },
}
