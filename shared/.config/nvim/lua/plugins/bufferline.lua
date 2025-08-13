return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = function(_, opts)
      opts.options = {
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(_, _, diag)
          local icons = {
            error = ' ',
            warning = ' ',
          }
          local ret = (diag.error and icons.error .. diag.error .. ' ' or '') .. (diag.warning and icons.warning .. diag.warning or '')
          return vim.trim(ret)
        end,
      }

      if (vim.g.colors_name or ''):find 'catppuccin' then
        opts.highlights = require('catppuccin.groups.integrations.bufferline').get()
      end

      vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
      vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
    end,
  },
}
