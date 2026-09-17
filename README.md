# Neovim Configuration

A modular Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Requirements

- Neovim 0.11 or later
- Git
- `ripgrep` for Telescope file and text search
- A C compiler and `make` for native plugin builds
- A Nerd Font for icons (enabled by default)
- A system clipboard provider appropriate for your platform

## Installation

Clone the repository to Neovim's configuration directory:

```sh
git clone git@github.com:kien5436/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

Start Neovim:

```sh
nvim
```

`lazy.nvim` bootstraps itself automatically and installs the configured plugins. Use `:Lazy` to inspect plugin status and `:Mason` to inspect language tools.

## Features

- LSP support for Lua, TypeScript, ESLint, Emmet, HTML, and CSS
- Blink completion with LuaSnip snippets, LSP suggestions, paths, LazyDev, and Codeium/Windsurf suggestions
- Treesitter syntax highlighting, indentation, folding, and automatic parser installation
- Telescope for finding files, text, buffers, help, diagnostics, and symbols
- Formatting through Conform, with manual formatting on `<leader>f`
- File explorer, statusline, indentation guides, comments, autopairs, todo comments, and Markdown rendering

## Key bindings

The leader key is `<Space>`. Run `:WhichKey` or press `<Space>` and wait for a complete, in-editor list.

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle the file explorer at the current file |
| `<leader>f` | Format the current buffer |
| `<leader>q` | Open the diagnostic location list |
| `<leader>d` | Show the diagnostic under the cursor |
| `<leader>sf` | Find files |
| `<leader>sg` | Search project text |
| `<leader>sw` | Search the word under the cursor |
| `<leader><leader>` | Search open buffers |
| `<leader>sh` | Search Neovim help |
| `grd` | Go to definition |
| `grr` | Find references |
| `gra` | Code action |
| `grn` | Rename symbol |
| `<F5>` | Start or continue debugging |
| `<F1>` / `<F2>` / `<F3>` | Step into / over / out while debugging |
| `<F7>` | Toggle the debugger UI |

In terminal mode, press `<Esc><Esc>` to return to Normal mode. Use `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` to move between splits.

## Maintenance

- Update plugins with `:Lazy update`; commit the resulting `lazy-lock.json` change when the update is verified.
- Update Mason-managed tools through `:Mason`.
- Diagnose the setup with `:checkhealth`.

## Credits

This project started from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). The configuration has since been reorganized and customized for everyday development use.
