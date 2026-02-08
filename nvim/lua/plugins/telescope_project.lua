return {
  {
    'nvim-telescope/telescope-project.nvim',
    enabled = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
  },
  {
    "SalOrak/whaler",
    enabled = false,
    dependencies = {
      "nvim-tree/nvim-tree.lua",  -- 添加 nvim-tree 作为依赖
    },
    opts = {
      -- Directories to be used as parent directories. Their subdirectories 
      -- are considered projects for Whaler.
      directories = {
          "path/to/parent/project", 
          { path = "path/to/another/parent/project", alias = "An alias!"}
      },
      -- Directories to be directly used as projects. No subdirectory lookup.
      oneoff_directories = {
          { path = "~/.config/", alias = "Config directory"}
      },

      picker = "telescope",

      telescope_opts = {
        results_title = false,
        layout_strategy = "horizontal",
        previewer = true,
        layout_config = {
            --preview_cutoff = 1000,
            height = 0.3,
            width = 0.4,
        },
        sorting_strategy = "ascending",
        border = true,
      },

      file_explorer = "nvimtree",
    },
  }
}
