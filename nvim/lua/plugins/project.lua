return {
  "coffebar/neovim-project",
  cmd = {
    "NeovimProjectDiscover",
  },
  keys = {
    {
      "<leader>p",
      "<cmd>NeovimProjectDiscover<CR>",
      desc = "NeovimProject discover",
    },
  },
  opts = {
    projects = { -- define project roots
      "~/Desktop/OIer/*",
      "~/projects/*",
      "~/.config/*",
    },
    picker = {
      type = "telescope",
    }
  },
  init = function()
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
  config = function(_, opts)
    require("neovim-project").setup(opts)

    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if not has_devicons then
      return
    end

    devicons.setup({
      default = true,
    })

    local function get_file_icon(name)
      local icon, hl = devicons.get_icon(name, nil, { default = true })
      if not icon or icon == "" then
        icon = ""
      end
      if not hl or hl == "" then
        if vim.fn.hlexists("DevIconDefault") == 1 then
          hl = "DevIconDefault"
        else
          hl = "Normal"
        end
      end
      return icon, hl
    end

    local preview = require("neovim-project.preview")
    if preview.__xtt_devicons_patched then
      return
    end
    preview.__xtt_devicons_patched = true

    local original_generate = preview.generate_project_preview
    preview.generate_project_preview = function(project_path)
      local result = original_generate(project_path)
      if type(result) ~= "table" or type(result.lines) ~= "table" then
        return result
      end

      local original_highlights = result.highlights or {}
      local new_highlights = {}
      for _, hl_info in ipairs(original_highlights) do
        if hl_info.start_col ~= 2 then
          table.insert(new_highlights, hl_info)
        end
      end
      result.highlights = new_highlights

      for i = 2, #result.lines do
        local line = result.lines[i]
        if type(line) == "string" then
          local status = line:sub(1, 2)
          local rest = line:sub(3)
          local first_space = rest:find(" ")
          if first_space then
            local name = rest:sub(first_space + 1)
            local is_dir = name:sub(-1) == "/"

            local icon, hl
            if is_dir then
              icon, hl = "", "NvimTreeFolderIcon"
            else
              icon, hl = get_file_icon(name)
            end

            result.lines[i] = status .. icon .. " " .. name

            table.insert(result.highlights, {
              line = i - 1,
              hl = hl,
              start_col = 2,
              end_col = 2 + vim.fn.strwidth(icon),
            })
          end
        end
      end

      return result
    end

    preview.clear_all_caches()
  end,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { "Shatur/neovim-session-manager" },
  },
}
