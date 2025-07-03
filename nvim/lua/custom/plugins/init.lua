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
  
}
