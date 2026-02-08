return {
  {
    "nvim-mini/mini.indentscope",
    event = "VeryLazy",
    init = function()
      local function disable_indentscope_for_current_buf()
        vim.b.miniindentscope_disable = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dashboard" },
        callback = disable_indentscope_for_current_buf,
        desc = "Disable mini.indentscope in dashboard",
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = { "DashboardLoaded" },
        callback = disable_indentscope_for_current_buf,
        desc = "Disable mini.indentscope when dashboard loads",
      })

      if vim.bo.filetype == "dashboard" then
        disable_indentscope_for_current_buf()
      end
    end,
    config = function()
      require("mini.indentscope").setup({})
    end,
  },
}
