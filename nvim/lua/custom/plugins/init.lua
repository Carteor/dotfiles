-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        'dhruvasagar/vim-zoom',
        keys = {
            { '<C-w>m', '<Plug>(zoom-toggle)', desc = 'Toggle Zoom' },
        },
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
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.surround').setup()
            require('mini.pairs').setup()
            require('mini.comment').setup()
            require('mini.ai').setup()
            require('mini.indentscope').setup({
                symbol = '|',
                draw = {
                    delay = 0,
                    animation = require('mini.indentscope').gen_animation.none(),
                },
            })
            -- Make indent scope subtle gray
            vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = '#555555', nocombine = true })
        end,
    },
 }
