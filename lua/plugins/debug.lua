-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

local js_based_languages = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local mason_nvim_dap = require 'mason-nvim-dap'

    dap.set_log_level 'TRACE'

    mason_nvim_dap.setup {
      ensure_installed = { 'js' },
    }

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { '/Users/nramirez/.local/share/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }
    dap.adapters.chrome = {
      type = 'executable',
      command = 'node',
      args = { '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' }, -- TODO adjust
    }

    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        -- Debug single nodejs files
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
        },
        -- Debug nodejs processes (make sure to add --inspect when you run the process)
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach',
          processId = require('dap.utils').pick_process,
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          continueOnAttach = true,
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach Port 9230',
          processId = require('dap.utils').pick_process,
          cwd = vim.fn.getcwd(),
          port = 9230,
          sourceMaps = true,
          continueOnAttach = true,
        },
        -- Debug web applications (client side)
        {
          type = 'chrome',
          request = 'launch',
          name = 'Launch & Debug Chrome',
          url = function()
            local co = coroutine.running()
            return coroutine.create(function()
              vim.ui.input({
                prompt = 'Enter URL: ',
                default = 'http://localhost:3000',
              }, function(url)
                if url == nil or url == '' then
                  return
                else
                  coroutine.resume(co, url)
                end
              end)
            end)
          end,
          -- webRoot = vim.fn.getcwd(),
          webRoot = '${workspaceFolder}',
          protocol = 'inspector',
          sourceMaps = true,
          userDataDir = false,
          port = 9230,
        },
        -- Divider for the launch.json derived configs
        {
          name = '----- ↓ launch.json configs ↓ -----',
          type = '',
          request = 'launch',
        },
      }
    end

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {},
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader><F11>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F4>', dapui.eval, { desc = 'Debug: Eval current expression' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    vim.keymap.set('n', '<leader>dr', function()
      dap.repl.open()
    end)
    vim.keymap.set('n', '<leader>dl', function()
      dap.run_last()
    end)
    vim.keymap.set('n', '<leader>da', function()
      if vim.fn.filereadable '.vscode/launch.json' then
        local dap_vscode = require 'dap.ext.vscode'
        dap_vscode.load_launchjs(nil, {
          ['pwa-node'] = js_based_languages,
          ['chrome'] = js_based_languages,
          ['pwa-chrome'] = js_based_languages,
        })
      end
      require('dap').continue()
    end, { desc = 'Debug: Run with Args' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = 'single',
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
