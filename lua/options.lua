-- fold: https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/

vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.foldcolumn = '0'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99 -- fold all by default: 1
vim.opt.foldlevelstart = 1 -- top level folds are opened
vim.opt.foldmethod = 'expr'
vim.opt.foldnestmax = 20
vim.opt.foldtext = ''
vim.opt.ignorecase = true
vim.opt.inccommand = 'split'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250

vim.schedule(function()
  -- Sync clipboard between OS and Neovim.
  vim.opt.clipboard = 'unnamedplus'
end)
