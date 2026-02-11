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
  end,
}
