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
      vim.keymap.set('n', '_', MiniFiles.open, { desc = 'Open mini.files (cwd)' })
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

      -- Icon provider
      local glyphs = {
        docs = '󰈙',
        env = '󰒓',
        eslint = '󰱺',
        git = '',
        github = '',
        node = '',
        pnpm = '',
        prettier = '',
        typescript = '',
        yarn = '󰱺',
      }
      local hls = {
        boring = 'MiniIconsGrey',
        config = 'MiniIconsYellow',
        declarations = 'MiniIconsPurple',
        dependencies = 'MiniIconsOrange',
        ignore = 'MiniIconsRed',
        javascript = 'MiniIconsYellow',
        lint = 'MiniIconsCyan',
        node = 'MiniIconsGreen',
        typescript = 'MiniIconsBlue',
      }
      require('mini.icons').setup {
        file = {
          ['.github/*'] = { glyph = glyphs.github, hl = hls.boring },
          ['.gitignore'] = { glyph = glyphs.git, hl = hls.ignore },
          ['.gitkeep'] = { glyph = glyphs.git, hl = hls.boring },
          ['.eslintrc.js'] = { glyph = glyphs.eslint, hl = hls.lint },
          ['.node-version'] = { glyph = glyphs.node, hl = hls.config },
          ['.prettierrc'] = { glyph = glyphs.prettier, hl = hls.lint },
          ['.prettierignore'] = { glyph = glyphs.prettier, hl = hls.ignore },
          ['.yarnrc.yml'] = { glyph = glyphs.yarn, hl = hls.config },
          ['eslint.config.js'] = { glyph = glyphs.eslint, hl = hls.lint },
          ['package.json'] = { glyph = glyphs.node, hl = hls.dependencies },
          ['pnpm-lock.yaml'] = { glyph = glyphs.pnpm, hl = hls.dependencies },
          ['pnpm-workspace.yaml'] = { glyph = glyphs.pnpm, hl = hls.config },
          ['README.md'] = { glyph = glyphs.docs, hl = hls.boring },
          ['tsconfig.build.json'] = { glyph = glyphs.typescript, hl = hls.config },
          ['tsconfig.json'] = { glyph = glyphs.typescript, hl = hls.config },
          ['yarn.lock'] = { glyph = glyphs.yarn, hl = hls.dependencies },
        },
        extension = {
          ['d.ts'] = { glyph = glyphs.typescript, hl = hls.declarations },
          ['ts'] = { glyph = glyphs.typescript, hl = hls.typescript },
        },
        directory = {},
      }
    end,
  },
}
