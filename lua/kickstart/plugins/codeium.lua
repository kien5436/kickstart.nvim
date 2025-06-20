return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    require('codeium').setup {
      virtual_text = {
        enabled = true,
      },
      default_filetype_enabled = true,
      filetypes = {
        html = true,
        typescript = true,
        javascript = true,
        css = true,
        json = true,
        java = true,
      },
    }
  end,
}
