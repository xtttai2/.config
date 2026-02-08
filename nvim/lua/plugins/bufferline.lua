return {
  "akinsho/bufferline.nvim",
  version = "*",
  enabled = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          separator = true,
          text_align = "left",
        },
      },
    },
  },
}
