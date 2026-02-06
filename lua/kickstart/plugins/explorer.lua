return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {}

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, noremap = true, silent = true, nowait = true }
    end

    vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>', opts 'Toggle file [e]xplorer')

    local api = require 'nvim-tree.api'

    vim.api.nvim_create_autocmd('BufEnter', {
      nested = true,
      callback = function()
        if vim.fn.bufname() == 'NvimTree_1' then
          return
        end

        api.tree.find_file { buf = vim.fn.bufnr() }
      end,
    })
  end,
}
