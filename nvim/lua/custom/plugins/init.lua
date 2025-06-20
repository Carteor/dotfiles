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
  {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting   -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- list of formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'checkmake',
        'prettier', -- ts/js formatter
        'stylua',   -- lua formatter
        'eslint_d', -- ts/js linter
        'shfmt',
        'ruff',
      },
      -- auto-install configured formatters & linters (with null-ls)
      automatic_installation = true,
    }

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
  }
}
