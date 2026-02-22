-- 行号
vim.opt.relativenumber = true -- 相对行号
vim.opt.signcolumn = "yes"    -- 始终在行号左侧保留符号的空间
vim.opt.number = true         -- 开启行号
vim.opt.cursorline = true

-- 终端用 24-bit 真色显示
vim.opt.termguicolors = true

-- 缩进
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- 启用鼠标
vim.opt.mouse:append("a")

-- 新窗口分裂到右与下，而不是左与上
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 禁止自动备份文件
vim.opt.backup = false

-- 全局只显示一条状态栏而不是每个窗口一条
vim.opt.laststatus = 3

vim.opt.scrolloff = 5
