return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {},
  config = function()
    local ts = require 'typescript-tools'
    ts.setup {
      settings = {
        tsserver_file_preferences = {
          importModuleSpecifierPreference = 'relative',
          importModuleSpecifierEnding = 'minimal',
        },
      },
    }
  end,
}
