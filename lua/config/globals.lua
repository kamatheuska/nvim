--
-- Global Options
--

-- Set <space> as the leader key
-- See `:help mapleader`
--
-- IMPORTANT: Must happen before plugins are loaded (otherwise wrong leader will be used)
--
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Format enabled globally conform
vim.b.disable_autoformat = false
vim.g.disable_autoformat = false

-- disable unwanted providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
