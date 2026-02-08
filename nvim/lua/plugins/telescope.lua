return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Telescope",
  keys = {
    {
      "<leader>f",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Telescope find files",
    },
    {
      "<leader>g",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Telescope live grep",
    },
    {
      "<leader>b",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope buffers",
    },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
    },
  },
}
