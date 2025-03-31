local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

local colors = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'colors',
      finder = finders.new_table {
        results = { 'red', 'green', 'blue' },
      },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          -- print(vim.inspect(selection))
          vim.api.nvim_put({ selection[1] }, '', false, true)
        end)
        return true
      end,
    })
    :find()
end

--
-- For documentation on typescript workspace commands
-- https://github.com/typescript-language-server/typescript-language-server?tab=readme-ov-file#workspace-commands-workspaceexecutecommand
--
local ts_commands = function(opts)
  opts = opts or {}
  local commands = {
    ORGANIZE_IMPORTS = 'Organize Imports',
    RENAME_FILE = 'Rename File',
    ADD_MISSING_IMPORTS = 'Add Missing Imports',
    REMOVE_UNUSED_IMPORTS = 'Remove Unused Imports',
    REMOVE_UNUSED = 'Remove Unused',
  }
  pickers
    .new(opts, {
      prompt_title = 'Typescript Commands',

      finder = finders.new_table {
        results = {
          commands.ORGANIZE_IMPORTS,
          commands.ADD_MISSING_IMPORTS,
          commands.REMOVE_UNUSED_IMPORTS,
          commands.REMOVE_UNUSED,
          commands.RENAME_FILE,
        },
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()

          if selection[1] == commands.ORGANIZE_IMPORTS then
            local params = {
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
              title = '',
            }
            vim.lsp.buf.execute_command(params)
            return
          end
          if selection[1] == commands.ADD_MISSING_IMPORTS then
            vim.lsp.buf.code_action {
              apply = true,
              context = {
                diagnostics = {},
                only = { 'source.addMissingImports.ts' },
              },
            }

            vim.cmd 'write'
            return
          end
          if selection[1] == commands.REMOVE_UNUSED_IMPORTS then
            vim.lsp.buf.code_action {
              apply = true,
              context = {
                diagnostics = {},
                only = { 'source.removeUnusedImports.ts' },
              },
            }
          end
          if selection[1] == commands.REMOVE_UNUSED then
            vim.lsp.buf.code_action {
              apply = true,
              context = {
                diagnostics = {},
                only = { 'source.removeUnused.ts' },
              },
            }
          end

          -- TODO: Implement this
          if selection[1] == commands.RENAME_FILE then
            local function rename_file()
              local source_file, target_file

              vim.ui.input({
                prompt = 'Source : ',
                completion = 'file',
                default = vim.api.nvim_buf_get_name(0),
              }, function(input)
                source_file = input
              end)
              vim.ui.input({
                prompt = 'Target : ',
                completion = 'file',
                default = source_file,
              }, function(input)
                target_file = input
              end)

              local params = {
                command = '_typescript.applyRenameFile',
                arguments = {
                  {
                    sourceUri = source_file,
                    targetUri = target_file,
                  },
                },
                title = '',
              }

              vim.lsp.util.rename(source_file, target_file)
              vim.lsp.buf.execute_command(params)
            end

            rename_file()
          end
        end)

        return true
      end,
    })
    :find()
end
return {
  colors = colors,
  ts_commands = ts_commands,
}
