# .config

This repository contains configuration files for:

- Neovim (Lazy.nvim-based setup)
- Kitty terminal
- Fish shell
- Starship prompt

The layout matches the XDG config convention (i.e. folders like `nvim/`, `fish/`, `kitty/` live under your config directory).

## Quick setup

Pick **copy** or **symlink**.

### Linux/macOS (XDG)

Your config directory is usually `~/.config`.

- Copy:
	- `nvim/` -> `~/.config/nvim/`
	- `fish/` -> `~/.config/fish/`
	- `kitty/` -> `~/.config/kitty/`
	- `starship.toml` -> `~/.config/starship.toml`

- Symlink (example):
	- `ln -s /path/to/this-repo/nvim ~/.config/nvim`

### Windows

Neovim and Kitty use different default locations on Windows.

- Neovim config:
	- Default: `%LOCALAPPDATA%\nvim\`
	- Place this repo’s `nvim/` as: `%LOCALAPPDATA%\nvim\`

- Starship config:
	- Default: `%USERPROFILE%\.config\starship.toml` (if you use XDG), otherwise set `STARSHIP_CONFIG`

- Fish / Kitty:
	- If you use Fish/Kitty on Windows, point them at this repo’s `fish/` and `kitty/` configs (exact locations depend on how you installed them).

## Neovim

### What’s included

- Plugin manager: `folke/lazy.nvim` (auto-clones on first launch)
- Theme: Everforest (`sainnhe/everforest`)
- LSP: uses Neovim built-in LSP enablement for:
	- `lua_ls` (Lua)
	- `clangd` (C/C++)
- Completion: `saghen/blink.cmp`
- Fuzzy finder: Telescope (configured to use `rg` and include hidden files)
- Treesitter with automatic parser installation for common languages
- DAP (debugger UI) with `codelldb` adapter and a C++ “compile then run” flow

### Dependencies

Required:

- Neovim **0.10+** (uses `vim.uv` and built-in LSP enablement)
- `git` (Lazy.nvim clones plugins)

Recommended (features used by this config):

- `ripgrep` (`rg`) — required for Telescope `live_grep` (this config explicitly calls `rg`)
- A C toolchain for Treesitter parser compilation
	- Linux/macOS: `gcc`/`clang` + `make`
	- Windows: any working C compiler toolchain in PATH

Optional (depending on what you use):

- `clangd` (C/C++ LSP)
- `lua-language-server` (Lua LSP)
- `g++` (used by the `<F5>` “compile & run” helper and the DAP compile step)
- Nerd Font (icons in UI components like devicons/statusline)

### First launch

1. Start Neovim.
2. Wait for Lazy.nvim to install plugins.

### LSP / tools installation

This setup includes `mason.nvim`, and `nvim/init.lua` prepends Mason’s `bin/` directory to `$PATH`.

Suggested workflow:

- Open Neovim and run `:Mason`
- Install what you need (examples):
	- `lua-language-server`
	- `clangd`
	- `codelldb`

### Useful keybindings (high-level)

- Leader key: `<Space>`
- Telescope:
	- `<leader>f` find files
	- `<leader>g` live grep
	- `<leader>b` buffers
- File tree: `<leader>e` toggle `nvim-tree`
- LSP:
	- `gd` definition
	- `gD` declaration
	- `grr` references (loads Telescope on demand)
- C++ run/debug:
	- `<F5>`: if there are DAP breakpoints -> continue debugging; otherwise compile with `g++` and run in a terminal split

## Kitty

Files:

- `kitty/kitty.conf` (includes `kitty/current-theme.conf`)

Notes / dependencies:

- Shell is set to `fish`
- Font is set to `FiraCode Nerd Font Mono`
- Theme file is Everforest Dark Medium

If you don’t have Fish or that font installed, update `kitty/kitty.conf` accordingly.

## Fish

Files:

- `fish/config.fish`

Notes / dependencies:

- Enables vi key bindings (`fish_vi_key_bindings`)
- Initializes Starship (`starship init fish | source`)

## Starship

File:

- `starship.toml`

Notes / dependencies:

- Designed around Nerd Fonts (the prompt uses powerline-style glyphs)
- Palette is Everforest (dark variants)

## Troubleshooting

- If Telescope `live_grep` fails: install `ripgrep` (`rg`) and ensure it’s on PATH.
- If Treesitter parser install fails: install a C compiler toolchain and retry `:TSUpdate`.
- If C++ `<F5>` compile/run fails: ensure `g++` is installed and on PATH.