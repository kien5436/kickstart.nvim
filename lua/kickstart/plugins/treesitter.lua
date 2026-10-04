return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local treesitter = require 'nvim-treesitter'
      -- The JSON parser also handles JSON with comments.
      vim.treesitter.language.register('json', 'jsonc')
      treesitter.setup {}

      local function start(buf)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
          return
        end
        local filetype = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang or not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        vim.bo[buf].syntax = ''
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not lang or not vim.tbl_contains(treesitter.get_available(), lang) then
            return
          end
          -- Install missing parsers asynchronously, then highlight the original buffer.
          treesitter.install({ lang }):await(function(err)
            if not err then
              vim.schedule(function()
                start(event.buf)
              end)
            end
          end)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
