return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    require('codeium').setup {
      enable_cmp_source = false, -- disable legacy `nvim-cmp`
      virtual_text = {
        enabled = false,
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
