return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Smooth scrolling etc
      require('mini.animate').setup()

      -- File browser
      require('mini.files').setup {}
      vim.keymap.set('n', '-', function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        MiniFiles.open(path)
        MiniFiles.reveal_cwd()
      end, { desc = 'Open mini.files' })

      -- Visual guide to block scope and indentation
      require('mini.indentscope').setup {
        symbol = '┆',
      }
      -- Alternatives: ~
      --   • left aligned solid
      --     • `▏`
      --     • `▎` (default)
      --     • `▍`
      --     • `▌`
      --     • `▋`
      --     • `▊`
      --     • `▉`
      --     • `█`
      --   • center aligned solid
      --     • `│`
      --     • `┃`
      --   • right aligned solid
      --     • `▕`
      --     • `▐`
      --   • center aligned dashed
      --     • `╎`
      --     • `╏`
      --     • `┆`
      --     • `┇`
      --     • `┊`
      --     • `┋`
      --   • center aligned double
      --     • `║`
    end,
  },
}
