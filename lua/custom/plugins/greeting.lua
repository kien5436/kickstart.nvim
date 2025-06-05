return {
  name = 'greeting',
  dir = vim.fn.stdpath 'config' .. '/lua/custom/plugins',
  lazy = false,
  priority = 1000,
  dev = true,
  event = 'VimEnter',
  config = function()
    local api = vim.api
    local group = api.nvim_create_augroup('CustomGreeter', { clear = true })

    local function center_text(text, width)
      local padding = math.max(0, math.floor((width - #text) / 2))
      return (' '):rep(padding) .. text
    end

    local function create_greeter()
      if vim.fn.argc() > 0 then
        return
      end

      local buf = api.nvim_create_buf(false, true)
      vim.opt_local.bufhidden = 'wipe'

      local ver = vim.version()
      local greeting = {
        '',
        ' ::::::::  :::    ::: :::::::::: :::::::::  :::        ::::::::   ::::::::  :::    :::',
        ':+:    :+: :+:    :+: :+:        :+:    :+: :+:       :+:    :+: :+:    :+: :+:   :+: ',
        '+:+        +:+    +:+ +:+        +:+    +:+ +:+       +:+    +:+ +:+        +:+  +:+  ',
        '+#++:++#++ +#++:++#++ +#++:++#   +#++:++#:  +#+       +#+    +:+ +#+        +#++:++   ',
        '       +#+ +#+    +#+ +#+        +#+    +#+ +#+       +#+    +#+ +#+        +#+  +#+  ',
        '+#+    #+# #+#    #+# #+#        #+#    #+# #+#       #+#    #+# #+#    #+# #+#   #+# ',
        ' ########  ###    ### ########## ###    ### ########## ########   ########  ###    ###',
        '',
        string.format('NVIM v%d.%d.%d', ver.major, ver.minor, ver.patch),
        '',
        ' 󰈙 New buffer     e',
        '\u{f017} Recent files   r',
        '\u{f011} Quit           q',
      }

      local function center_greeting()
        vim.opt_local.modifiable = true

        local centered_greeting = {}
        local win_height = vim.o.lines
        local win_width = vim.o.columns
        local top_padding = math.max(0, math.floor((win_height - #greeting) / 2))

        for _ = 1, top_padding do
          table.insert(centered_greeting, '')
        end

        for _, line in ipairs(greeting) do
          table.insert(centered_greeting, line == '' and line or center_text(line, win_width))
        end

        api.nvim_buf_set_lines(buf, 0, -1, false, centered_greeting)
        vim.opt_local.modifiable = false
        vim.opt_local.filetype = 'greeting'
      end

      center_greeting()

      local keymaps = {
        ['n'] = {
          ['e'] = ':enew<CR>',
          ['q'] = ':qa<CR>',
          ['r'] = ':Telescope oldfiles<CR>',
        },
      }

      for mode, maps in pairs(keymaps) do
        for lhs, rhs in pairs(maps) do
          vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = buf })
        end
      end

      api.nvim_set_current_buf(buf)

      api.nvim_create_autocmd('VimResized', {
        group = group,
        buffer = buf,
        callback = center_greeting,
      })
    end

    api.nvim_create_autocmd('VimEnter', {
      group = group,
      callback = create_greeter,
    })
  end,
}
