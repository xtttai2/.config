vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout=300
    })
  end
})

-- 不要在新行自动延续注释（Enter / o / O）
-- 'r': 按 Enter 时延续注释
-- 'o': 用 o/O 新开行时延续注释
vim.opt.formatoptions:remove({ 'r', 'o' })
local formatopts_group = vim.api.nvim_create_augroup('NoAutoCommentNewline', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = formatopts_group,
  pattern = '*',
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

local term_group = vim.api.nvim_create_augroup('AutoInsertTerminal', { clear = true })
vim.api.nvim_create_autocmd({ 'TermOpen', 'TermEnter' }, {
  group = term_group,
  pattern = 'term://*',
  callback = function()
    -- 避免在某些插件/时序下直接 startinsert 失效
    vim.schedule(function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd('startinsert')
      end
    end)
  end,
})