vim.lsp.enable 'lua_ls'
vim.lsp.enable 'clangd'

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = event.buf, desc = 'LSP: Goto Definition' })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = event.buf, desc = 'LSP: Goto Declaration' })
    vim.keymap.set('n', 'grr', function()
      require('lazy').load({ plugins = { 'telescope.nvim' } })
      require('telescope.builtin').lsp_references()
    end, { buffer = event.buf, desc = 'LSP: Goto References' })

    vim.diagnostic.config({
      virtual_text = true,
      update_in_insert = true,
      float = {
        severity_sort = true,
      },
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
        linehl = {
          [vim.diagnostic.severity.ERROR] = "ErrorLine",
          [vim.diagnostic.severity.WARN] = "WarnLine",
          [vim.diagnostic.severity.HINT] = "HintLine",
          [vim.diagnostic.severity.INFO] = "InfoLine",
        },
      },
    })

  end
})


-- highlight references under cursor on hold
local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    -- 确保服务器支持 documentHighlight
    if client.supports_method("textDocument/documentHighlight") then
      -- 停留触发高亮
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      -- 移动/切换模式时清理
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
vim.o.updatetime = 300
