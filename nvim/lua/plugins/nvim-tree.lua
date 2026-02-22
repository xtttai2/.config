return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile", "NvimTreeOpen" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree Toggle" },
  },
  opts = {
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      api.config.mappings.default_on_attach(bufnr)

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      -- Use `h` to go to parent directory (same behavior as default `-`).
      vim.keymap.set("n", "h", api.tree.change_root_to_parent, opts("Up"))

      -- Use `l`: on file -> open; on directory -> cd (change root into it).
      vim.keymap.set("n", "l", function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type == "directory" then
          api.tree.change_root_to_node(node)
        else
          api.node.open.edit()
        end
      end, opts("Open or CD"))
    end,
    renderer = {
      indent_markers = { enable = true },
    },
    actions = {
      change_dir = {
        enable = true,
      },
    },
    sync_root_with_cwd = true,
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)

    vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
      nested = false,
      callback = function(e)
        local tree = require("nvim-tree.api").tree
        if not tree.is_visible() then
          return
        end

        local winCount = 0
        for _, winId in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(winId).focusable then
            winCount = winCount + 1
          end
        end

        if e.event == "QuitPre" and winCount == 2 then
          vim.api.nvim_cmd({ cmd = "qall" }, {})
        end

        if e.event == "BufEnter" and winCount == 1 then
          vim.defer_fn(function()
            tree.toggle({ find_file = true, focus = true })
            tree.toggle({ find_file = true, focus = false })
          end, 10)
        end
      end,
    })
  end,
}
