return {
  'windwp/nvim-ts-autotag',
  lazy = true,
  event = {
    'BufReadPre',
    'BufNewFile',
  },
  opts = {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  },
}
