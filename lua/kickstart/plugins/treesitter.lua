return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    config = function()
      local treesitter = require 'nvim-treesitter'
      -- The JSON parser also handles JSON with comments.
      vim.treesitter.language.register('json', 'jsonc')
      treesitter.setup {}

      local install_dir = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath 'data', 'site'))
      local installing = {} --- @type table<string, boolean>

      -- Neovim caches runtimepath file lookups per session: query
      -- files that appear on the rtp after startup (e.g. written by
      -- :TSInstall) stay invisible to vim.treesitter.query.get until
      -- 'rtp' is modified. Appending and immediately removing a dummy
      -- entry busts that cache while leaving the option byte-identical.
      local function rescan_runtimepath()
        local tmp = vim.fn.tempname() -- never created, so harmless
        vim.opt.rtp:append(tmp)
        vim.opt.rtp:remove(tmp)
      end

      local function is_installed(lang)
        return vim.tbl_contains(treesitter.get_installed 'parsers', lang)
      end

      -- A parser counts as usable only when it is installed in the
      -- managed location (install_dir; stray .so files elsewhere on
      -- the rtp, e.g. leftovers from the pre-main-branch layout inside
      -- the plugin dir, must not count). Builtin parsers shipped with
      -- Neovim are always usable.
      local function managed_parser_path(lang)
        local matches = vim.api.nvim_get_runtime_file('parser/' .. lang .. '.so', true)
        local first = matches[1]
        if not first then
          return nil
        end
        first = vim.fs.normalize(first)
        if vim.startswith(first, install_dir) then
          return first
        end
        if is_installed(lang) then
          -- Installed per the plugin, but the .so resolving first on
          -- the rtp is a shadow copy: treat as NOT usable so we
          -- reinstall rather than load the stale binary.
          return nil
        end
        -- Not plugin-managed: usable only if nothing else provides it
        -- (i.e. a Neovim builtin).
        return first
      end

      local function has_queries(lang)
        return vim.treesitter.query.get(lang, 'highlights') ~= nil
      end

      local function is_ready(lang)
        return managed_parser_path(lang) ~= nil and has_queries(lang)
      end

      local function start(buf)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
          return
        end
        local filetype = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang or not pcall(vim.treesitter.start, buf, lang) then
          return
        end
        -- Only disable Vim regex syntax when treesitter highlights exist;
        -- otherwise the buffer would end up with no highlighting at all.
        if has_queries(lang) then
          vim.bo[buf].syntax = ''
        end
        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        -- Folding is window-local and the global default is already
        -- expr, so buffers with a folds query need nothing here. Only
        -- downgrade windows showing buffers WITHOUT one — otherwise
        -- the global treesitter foldexpr has nothing to evaluate and
        -- folding breaks for that window.
        if not vim.treesitter.query.get(lang, 'folds') then
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            vim.wo[win].foldmethod = 'manual'
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not lang then
            return
          end
          -- Managed parser AND queries available: start now.
          -- (A parser .so alone is not enough — without highlight
          -- queries the buffer would lose all syntax coloring, so
          -- install first in that case too.)
          -- Installed per get_installed but queries invisible: either a
          -- stale runtimepath cache (bust it and recheck) or a genuinely
          -- incomplete install (fall through to reinstall below).
          if is_installed(lang) and not has_queries(lang) then
            rescan_runtimepath()
          end
          if is_ready(lang) then
            start(event.buf)
            return
          end
          if installing[lang] or not vim.tbl_contains(treesitter.get_available(), lang) then
            -- Install already running for this language, or the
            -- language is not a known treesitter parser: best effort
            -- with whatever is loadable (builtins), if anything.
            if managed_parser_path(lang) then
              start(event.buf)
            end
            return
          end
          -- Install missing parser + queries asynchronously, then start
          -- the original buffer after re-validating it (it may have been
          -- closed, wiped, or given another filetype meanwhile).
          installing[lang] = true
          local buf = event.buf
          local ft = vim.bo[buf].filetype
          treesitter.install({ lang }):await(function(err)
            installing[lang] = nil
            if err then
              require('nvim-treesitter.log').error('treesitter install failed for ' .. lang .. ': ' .. tostring(err))
              return
            end
            vim.schedule(function()
              -- The install wrote new files; make them visible to this
              -- session before deciding anything about the buffer.
              rescan_runtimepath()
              if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == ft then
                start(buf)
              end
            end)
          end)
        end,
      })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
