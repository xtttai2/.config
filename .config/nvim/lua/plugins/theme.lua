return {
  'sainnhe/everforest',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.everforest_disable_italic_comment = true
    vim.g.everforest_diagnostic_line_highlight = true
    vim.g.everforest_diagnostic_virtual_text = 'highlighted'
    vim.cmd [[colorscheme everforest]]
  end,
}
