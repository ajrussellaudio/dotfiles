return {
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('blame').setup {}

      vim.keymap.set('n', '<leader>gb', ':BlameToggle<CR>', { desc = 'Toggle [G]it [B]lame' })
    end,
  },
}
