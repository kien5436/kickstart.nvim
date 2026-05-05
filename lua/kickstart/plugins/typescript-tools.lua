return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    settings = {
      tsserver_max_memory = 4096,
      tsserver_format_options = {
        semicolons = 'insert',
      },
      tsserver_file_preferences = {
        quotePreference = 'single',
      },
    },
  },
}
