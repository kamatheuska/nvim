--
-- Setting Options
--
-- See `:help vim.opt`
--
-- You can change these options as you wish!
--  For more options, you can see `:help option-list`
--

vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.tabstop = 4

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Open vim buffer instead of floating window for lazygit
-- https://github.com/kdheepak/lazygit.nvim/issues/22
-- Set GIT_EDITOR to use nvr if Neovim and nvr are available
if vim.fn.has 'nvim' == 1 and vim.fn.executable 'nvr' == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
