vim.g.mapleader = ' '

vim.keymap.set('n', '<M-s>', '<C-w>s')
vim.keymap.set('n', '<M-v>', '<C-w>v')

vim.keymap.set('n', '<M-h>','<C-w>h')
vim.keymap.set('n', '<M-j>','<C-w>j')
vim.keymap.set('n', '<M-k>','<C-w>k')
vim.keymap.set('n', '<M-l>','<C-w>l')

vim.keymap.set('n', '<M-q>', '<Cmd>q<CR>')
vim.keymap.set('n', '<M-S-q>', '<Cmd>q!<CR>')

vim.keymap.set('n', '<C-H>', '<Cmd>bprevious<CR>')
vim.keymap.set('n', '<C-L>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<leader>k', '<Cmd>bdelete<CR>')
vim.keymap.set('n', '<leader><S-K>', '<Cmd>bdelete!<CR>')

vim.keymap.set({'n', 'v'}, '<M-e>','"+')

vim.keymap.set('i', '<Tab>', function()
  local ok, suggestion = pcall(require, 'copilot.suggestion')
  if ok and suggestion.is_visible() then
    suggestion.accept()
    return
  end

  local ok_blink, blink = pcall(require, 'blink.cmp')
  if ok_blink and blink.is_menu_visible and blink.is_menu_visible() then
    blink.accept()
    return
  end

  local keys = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end, { silent = true })


local function oi_run_cpp_in_terminal()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)

  vim.cmd('silent update')

  local dir = vim.fn.fnamemodify(file, ':p:h')
  local base = vim.fn.fnamemodify(file, ':t')
  local out = vim.fn.fnamemodify(file, ':t:r')

  local is_win = vim.fn.has('win32') == 1
  local out_exe = is_win and (out .. '.exe') or out

  local cmd
  if is_win then
    cmd = table.concat({
      'cd /d ' .. vim.fn.shellescape(dir),
      'g++ ' .. vim.fn.shellescape(base) .. ' -Wall -o ' .. vim.fn.shellescape(out_exe),
      '.\\' .. out_exe,
    }, ' && ')

    vim.cmd('botright split')
    vim.cmd('resize 15')
    vim.cmd('terminal cmd.exe /c ' .. vim.fn.shellescape(cmd))
  else
    cmd = table.concat({
      'cd ' .. vim.fn.shellescape(dir),
      'g++ ' .. vim.fn.shellescape(base) .. ' -Wall -o ' .. vim.fn.shellescape(out_exe),
      './' .. vim.fn.shellescape(out_exe),
    }, ' && ')

    vim.cmd('botright split')
    vim.cmd('resize 15')
    vim.cmd('terminal bash -lc ' .. vim.fn.shellescape(cmd))
  end
end

local function oi_has_dap_breakpoints(bufnr)
	local ok_bp, breakpoints = pcall(require, 'dap.breakpoints')
	if not ok_bp then
		return false
	end
	local by_buf = breakpoints.get(bufnr)
	local bps = by_buf and by_buf[bufnr] or nil
	return bps ~= nil and #bps > 0
end

local function oi_f5_cpp_smart()
	local bufnr = vim.api.nvim_get_current_buf()
	if oi_has_dap_breakpoints(bufnr) then
		local ok_dap, dap = pcall(require, 'dap')
		if ok_dap then
			dap.continue()
			return
		end
	end
	oi_run_cpp_in_terminal()
end

vim.keymap.set('n', '<F5>', oi_f5_cpp_smart, { desc = 'CPP: DAP if breakpoints else run' })
