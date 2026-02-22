vim.g.mapleader = ' '

vim.keymap.set('n', '<M-s>', '<C-w>s')
vim.keymap.set('n', '<M-v>', '<C-w>v')

vim.keymap.set('n', '<C-H>', '<Cmd>bprevious<CR>')
vim.keymap.set('n', '<C-L>', '<Cmd>bnext<CR>')
vim.keymap.set('n', '<leader>k', '<Cmd>bdelete<CR>')
vim.keymap.set('n', '<leader><S-K>', '<Cmd>bdelete!<CR>')

vim.keymap.set({'n', 'v'}, '<M-e>','"+')

vim.keymap.set('n', '<M-h>','<C-w>h')
vim.keymap.set('n', '<M-j>','<C-w>j')
vim.keymap.set('n', '<M-k>','<C-w>k')
vim.keymap.set('n', '<M-l>','<C-w>l')

local function oi_run_cpp_in_terminal()
	local buf = vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(buf)

	-- 仅在有修改时写盘，避免无意义改动时间戳
	vim.cmd('silent update')

	local dir = vim.fn.fnamemodify(file, ':p:h')
	local base = vim.fn.fnamemodify(file, ':t')
	local out = vim.fn.fnamemodify(file, ':t:r')

	local cmd = table.concat({
		'cd ' .. vim.fn.shellescape(dir),
		'g++ ' .. vim.fn.shellescape(base) .. ' -Wall -o ' .. vim.fn.shellescape(out),
		'./' .. vim.fn.shellescape(out),
	}, ' && ')

	-- 下方弹出终端并聚焦输入
	vim.cmd('botright split')
	vim.cmd('resize 15')
	vim.cmd('terminal bash -lc ' .. vim.fn.shellescape(cmd))
	-- vim.cmd('startinsert')
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
