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
      vim.fn.sign_define(
        'DapBreakpoint',
        { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '', texthl = 'DapBreakpointCondition', linehl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' }
      )

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

        local is_win = vim.fn.has('win32') == 1
        if is_win then
          vim.cmd('terminal cmd.exe /c ' .. vim.fn.shellescape(compile_cmd_tty))
        else
          vim.cmd('terminal bash -lc ' .. vim.fn.shellescape(compile_cmd_tty))
        end

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


      local is_win = vim.fn.has("win32") == 1
      local codelldb_cmd = "codelldb"

      if is_win then
        codelldb_cmd = vim.fs.joinpath(
          vim.fn.stdpath("data"),
          "mason",
          "packages",
          "codelldb",
          "extension",
          "adapter",
          "codelldb.exe"
        )
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_cmd,
          args = { "--port", "${port}" },
          detached = false,
        },
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

            local out_no_ext = vim.fn.fnamemodify(file, ':r')
            local out_path = is_win and (out_no_ext .. '.exe') or out_no_ext

            local compile_cmd_tty
            if is_win then
              compile_cmd_tty = table.concat({
                'cd /d ' .. vim.fn.shellescape(dir),
                'g++ ' .. vim.fn.shellescape(base) .. ' -g -Wall -o ' .. vim.fn.shellescape(out_path),
              }, ' && ')
            else
              compile_cmd_tty = table.concat({
                'cd ' .. vim.fn.shellescape(dir),
                'g++ ' .. vim.fn.shellescape(base) .. ' -g -Wall -o ' .. vim.fn.shellescape(out_path),
              }, ' && ')
            end

            local output
            if is_win then
              output = vim.fn.system({ 'cmd.exe', '/c', compile_cmd_tty .. ' 2>&1' })
            else
              output = vim.fn.system({ 'bash', '-lc', compile_cmd_tty .. ' 2>&1' })
            end

            if vim.v.shell_error ~= 0 then
              show_gpp_output_in_terminal(compile_cmd_tty)
              return dap.ABORT
            end

            return out_path
          end,
          args = {},
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}

