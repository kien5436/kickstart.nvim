return {
  'echasnovski/mini.bufremove',
  version = '*',
  config = function()
    require('mini.bufremove').setup()
  end,
  keys = {
    {
      '<leader>x',
      function()
        require('mini.bufremove').delete(0, false)
      end,
      desc = 'Delete buffer (keep layout)',
    },
    {
      '<leader>X',
      function()
        require('mini.bufremove').wipeout(0, false)
      end,
      desc = 'Wipeout buffer (keep layout)',
    },
  },
}
