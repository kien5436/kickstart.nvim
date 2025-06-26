-- tailwind-tools.lua
return {
  'luckasRanarison/tailwind-tools.nvim',
  name = 'tailwind-tools',
  build = ':UpdateRemotePlugins',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- optional
    'neovim/nvim-lspconfig', -- optional
  },
  opts = {
    -- This plugin overrides server settings by default so you should define your config here than in `lspconfig.lua`
    server = {
      settings = {
        classAttributes = { 'class', 'className', 'class:list', 'classList', 'ngClass', 'styleClass' },
        includeLanguages = {},
      },
    },
    keymaps = {
      smart_increment = {
        enabled = false,
      },
    },
  }, -- your configuration
}
