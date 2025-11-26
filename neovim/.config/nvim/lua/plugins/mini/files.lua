-- File browser
return {
  'nvim-mini/mini.files',
  version = false,
  config = function()
    require('mini.files').setup {
      windows = {
        preview = true,
        width_focus = 40,
        width_no_focus = 10,
        width_preview = math.max(50, math.floor(vim.o.columns / 2)),
      },
    }
    vim.keymap.set('n', '_', MiniFiles.open, { desc = 'Open mini.files (cwd)' })
    vim.keymap.set('n', '-', function()
      local buf_name = vim.api.nvim_buf_get_name(0)
      local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
      MiniFiles.open(path)
      MiniFiles.reveal_cwd()
    end, { desc = 'Open mini.files' })
  end,
}
