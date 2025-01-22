-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +1<CR>', { desc = "Increase window's width", noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -1<CR>', { desc = "Decrease window's width", noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +1<CR>', { desc = "Increase window's height", noremap = true, silent = true })
vim.keymap.set('n', '<C-Up>', ':resize -1<CR>', { desc = "Decrease window's height", noremap = true, silent = true })
vim.keymap.set('i', '<S-Tab>', '<BS>', { noremap = true })
vim.keymap.set('n', '<C-s>', ':write<CR>', { desc = 'Write to file' })
vim.keymap.set('n', '<A-z>', ':set wrap!<CR>', { desc = 'Toggle word wrap', noremap = true, silent = true })
vim.keymap.set('n', '<C-a>', 'gg0VG', { desc = 'Select all', noremap = true, silent = true })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

if vim.fn.has 'wsl' == 1 then
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = "Put yanked text to Windows's clipboard",
    group = vim.api.nvim_create_augroup('wsl-yank', { clear = true }),
    callback = function()
      vim.fn.system('clip.exe', vim.fn.getreg '"')
    end,
  })
end
