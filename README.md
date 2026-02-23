# Neovim

![](https://cdn.jsdelivr.net/gh/xtttai2/img/nvim1.png)

![](https://cdn.jsdelivr.net/gh/xtttai2/img/nvim2.png)

## Dependencies

Required:
- Neovim 0.11+(nightly)
- `git`

Recommended:
- [Nerd Font](https://www.nerdfonts.com/) (to display icons)
- `ripgrep`(`rg`) & `fd` (for telescope)
- `curl` (for treesitter and blink)
- `tar` & [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md)(0.26.1+) & a C compiler in your path (for treesitter)

Optional(primarily for OIers):
- `clangd` (for C/C++ LSP)
- `lua-language-server` (for Lua LSP)
- `g++` (to compile cpp files)
- `codelldb` (for dap)

\* You can install `clangd`, `lua-language-server` and `codelldb` by running `:MasonInstall clangd lua-language-server codelldb` in nvim.