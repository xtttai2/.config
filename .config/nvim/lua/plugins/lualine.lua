return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        disabled_filetypes = {
          statusline = { "dashboard" },
          winbar = { "dashboard" },
        },
      },
      sections = {
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = false,
            path = 0,
            symbols = {
              modified = "●",
              readonly = "",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
      },
    })
  end,
}
