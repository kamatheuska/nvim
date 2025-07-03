return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_auto_close = 0
  end,
  keys = {
    { '<leader>om', '<cmd>MarkdownPreview<cr>', desc = 'Markdown Preview' },
  },
  ft = { 'markdown' },
}
