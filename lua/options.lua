-- fold: https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/

vim.o.autoindent = true
vim.o.breakindent = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99 -- fold all by default: 1
vim.o.foldlevelstart = 0 -- top level folds are opened
vim.o.foldmethod = 'expr'
vim.o.foldnestmax = 20
vim.o.foldtext = ''
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.mouse = 'a'
vim.o.number = true
vim.o.scrolloff = 10
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 250
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.schedule(function()
  -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = 'unnamedplus'
end)
