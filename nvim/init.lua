vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH


-- vim.o.winborder = "rounded"

-- Speed up startup by caching Lua module loads (Neovim 0.9+)
if vim.loader then
  vim.loader.enable()
end


require("core.disable")
require("core.options")
require("core.keymap")
require("core.autocmds")

-- Load LSP setup early so it also applies to new files opened via :e foo.ext
-- (BufNewFile happens after Neovim's filetype detection autocmds, so deferring
-- can miss the initial FileType event and prevent LSP auto-attach.)
require("lsp.lsp")

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = {
    lazy = true,
  },
  install = { colorscheme = { "everforest", "habamax" } },
  checker = { enabled = false },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "gzip",
        "matchit",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "rplugin",
        "shada",
        "spellfile",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})




vim.fn.sign_define(
  'DapBreakpoint',
  { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' }
)
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = '', texthl = 'DapBreakpointCondition', linehl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' }
)
