return {
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- 只屏蔽 dap.ABORT 触发的 "Run aborted" 提示，避免编译失败时出现额外输出
      do
        local dap_utils = require("dap.utils")
        local orig_notify = dap_utils.notify
        dap_utils.notify = function(msg, log_level)
          if msg == "Run aborted" then
            return
          end
          return orig_notify(msg, log_level)
        end
      end

      local function show_gpp_output_in_terminal(compile_cmd_tty)
        vim.cmd('botright split')
        vim.cmd('resize 12')
        vim.cmd('terminal bash -lc ' .. vim.fn.shellescape(compile_cmd_tty))
        -- 进入终端输入模式（也会被 TermOpen autocmd 兜底）
        vim.cmd('startinsert')
      end

      -- 调试程序需要 stdin 时，自动把焦点切到集成终端并进入输入模式
      dap.defaults.codelldb = dap.defaults.codelldb or {}
      dap.defaults.codelldb.focus_terminal = true
      local function focus_codelldb_terminal_win()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == 'terminal' and vim.b[buf]['dap-type'] == 'codelldb' then
            vim.api.nvim_set_current_win(win)
            vim.cmd('startinsert')
            return true
          end
        end
        return false
      end

      local function focus_codelldb_terminal_with_retry(tries)
        if focus_codelldb_terminal_win() then
          return
        end
        if tries <= 0 then
          return
        end
        vim.defer_fn(function()
          focus_codelldb_terminal_with_retry(tries - 1)
        end, 80)
      end

      dap.listeners.after.event_initialized.focus_dap_terminal = function()
        vim.schedule(function()
          focus_codelldb_terminal_with_retry(20)
        end)
      end

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      dapui.setup({})

      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "OpenDebugAD7",
        options = { detached = false },
      }

      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          console = "integratedTerminal",
          terminal = "integrated",
          program = function()
            vim.cmd('silent update')

            local file = vim.api.nvim_buf_get_name(0)
            if file == '' then
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end

            if vim.fn.fnamemodify(file, ':e') ~= 'cpp' then
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end

            local dir = vim.fn.fnamemodify(file, ':p:h')
            local base = vim.fn.fnamemodify(file, ':t')
            local out = vim.fn.fnamemodify(file, ':r')
            local compile_cmd_tty = table.concat({
              'cd ' .. vim.fn.shellescape(dir),
              'g++ ' .. vim.fn.shellescape(base) .. ' -g -Wall -o ' .. vim.fn.shellescape(out),
            }, ' && ')
            local compile_cmd_capture = compile_cmd_tty .. ' 2>&1'
            local output = vim.fn.system({ 'bash', '-lc', compile_cmd_capture })
            if vim.v.shell_error ~= 0 then
              -- 失败时用终端重跑一次，获得和手动 F5 一样的彩色/格式化输出
              show_gpp_output_in_terminal(compile_cmd_tty)
              return dap.ABORT
            end
            return out
          end,
          args = {},
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
