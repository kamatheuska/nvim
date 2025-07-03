return {
  -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  keys = {

    { '<leader>c', group = '[C]ode', hidden = true },
    { '<leader>d', group = '[D]ocument', hidden = true },
    { '<leader>r', group = '[R]ename', hidden = true },
    { '<leader>s', group = '[S]earch', hidden = true },
    { '<leader>w', group = '[W]orkspace', hidden = true },
    { '<leader>t', group = '[T]oggle', hidden = true },
    { '<leader>h', group = 'Git [H]unk', hidden = true },
    { '<leader>h', group = 'Git [H]unk', mode = 'v' },
  },
}
