local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
local is_windows = vim.fn.has("win32") == 1
local sep = is_windows and ";" or ":"

vim.env.PATH = mason_bin .. sep .. (vim.env.PATH or "")
-- vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- vim.o.winborder = "rounded"

-- Speed up startup by caching Lua module loads (Neovim 0.9+)
if vim.loader then
  vim.loader.enable()
end

require("core.disable")
require("core.options")
require("core.keymap")
require("core.autocmds")

-- Defer LSP setup until the first file is opened/created.
-- Using BufReadPre ensures this runs before FileType so LSP can still auto-attach.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("InitLspOnce", { clear = true }),
  once = true,
  callback = function()
    require("lsp.lsp")
  end,
})

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
