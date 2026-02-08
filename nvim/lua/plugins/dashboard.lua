return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  -- enabled = false,
  config = function()
    local v = vim.version()
    local nvim_version = string.format('NVIM v%d.%d.%d', v.major, v.minor, v.patch)
    require('dashboard').setup {
      theme = 'doom',
      disable_move = false,
      config = {
        header = { nvim_version },
        center = {},
        footer = function()
          local stats = require('dashboard.utils').get_package_manager_stats()
          local lines = {
            '',
            'Nvim is open source and freely distributable',
            'https://neovim.io/#chat',
            '',
          }

          if stats.name == 'lazy' then
            table.insert(lines, string.format('Startuptime: %.2f ms', stats.time))
            table.insert(
              lines,
              string.format('Plugins: %d loaded / %d installed', stats.loaded, stats.count)
            )
          end

          return lines
        end,
        vertical_center = true,
      }
    }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'DashboardLoaded',
      callback = function()
        vim.defer_fn(function()
          pcall(vim.api.nvim_clear_autocmds, { group = 'DashboardDoomCursor', buffer = 0 })
        end, 10)

        local bufnr = vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].filetype ~= 'dashboard' then
          return
        end

        vim.api.nvim_set_hl(0, 'DashboardHeader', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'DashboardFooterPrimary', { link = 'Normal' })
        vim.api.nvim_set_hl(0, 'DashboardFooterStartup', { link = 'Normal' })

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        for i, line in ipairs(lines) do
          if line:find('Startuptime:') then
            vim.api.nvim_buf_add_highlight(bufnr, 0, 'DashboardFooterStartup', i - 1, 0, -1)
          elseif line:find('Nvim is open source and freely distributable')
            or line:find('https://neovim.io')
            or line:find('Plugins:') then
            vim.api.nvim_buf_add_highlight(bufnr, 0, 'DashboardFooterPrimary', i - 1, 0, -1)
          end
        end
      end,
    })
  end,
  -- dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
