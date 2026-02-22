return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ensure_installed = {
      -- Neovim / editing basics
      "lua",
      "vim",
      "vimdoc",
      "query",
      "regex",

      -- Config / docs
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",

      -- Git / devops
      "gitignore",
      "gitcommit",
      "diff",
      "dockerfile",

      -- C/C++ toolchain
      "c",
      "cpp",
      "cmake",
      "make",

      -- Common languages
      "python",
      "java",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "rust",

      -- Web
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
    }

    local ensure_set = {}
    for _, lang in ipairs(ensure_installed) do
      ensure_set[lang] = true
    end

    local function install_missing(langs)
      local ok_config, ts_config = pcall(require, "nvim-treesitter.config")
      local ok_install, ts_install = pcall(require, "nvim-treesitter.install")
      if not (ok_config and ok_install) then
        return
      end

      local installed = ts_config.get_installed("parsers")
      local installed_set = {}
      for _, lang in ipairs(installed) do
        installed_set[lang] = true
      end

      local missing = {}
      for _, lang in ipairs(langs) do
        if not installed_set[lang] then
          table.insert(missing, lang)
        end
      end

      if #missing > 0 then
        ts_install.install(missing, { summary = true })
      end
    end

    -- Install your preferred parsers (in background) and keep them updated via :TSUpdate.
    vim.schedule(function()
      install_missing(ensure_installed)
    end)

    -- Enable treesitter highlighting for buffers that have parsers.
    -- If a parser isn't installed yet, try to install it when it is in ensure_installed.
    local installing = {}
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local bufnr = args.buf
        local ft = vim.bo[bufnr].filetype

        local lang
        local ok_lang, lang_mod = pcall(function()
          return vim.treesitter.language
        end)
        if ok_lang and lang_mod and lang_mod.get_lang then
          lang = lang_mod.get_lang(ft)
        else
          lang = ft
        end

        if lang and ensure_set[lang] and not installing[lang] then
          local ok_start = pcall(vim.treesitter.start, bufnr)
          if not ok_start then
            installing[lang] = true
            vim.schedule(function()
              install_missing({ lang })
              installing[lang] = nil
            end)
          end
        else
          pcall(vim.treesitter.start, bufnr)
        end
      end,
    })

    -- If this plugin is loaded in response to BufNewFile, FileType may have already fired.
    pcall(vim.treesitter.start, vim.api.nvim_get_current_buf())
  end,
}
