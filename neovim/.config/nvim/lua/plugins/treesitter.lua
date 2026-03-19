vim.g.ts_install = {
  -- JavaScript
  'javascript',
  -- 'javascriptreact',
  'json',
  'jsx',
  'typescript',
  -- 'typescriptreact',
  'tsx',
  'astro',

  -- Other web dev
  'css',
  'html',
  'groq', -- best parser ever
  'regex',

  -- Other langs
  'go',
  'gomod',
  'gowork',
  'gosum',
  'zig',

  -- Neovim
  'lua',
  'luadoc',
  'query', -- Treesitter query lang
  'vim',
  'vimdoc',

  -- Config
  'toml',
  'yaml',

  -- Docs
  'markdown',
  'markdown_inline',

  -- git
  'diff',
  -- 'gitconfig',
  'gitignore',

  -- Shell
  'bash',
  'tmux',

  -- Other
  'supercollider',
}

return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',

    config = function()
      local nvim_ts = require 'nvim-treesitter'
      nvim_ts.setup()

      local ts_install = vim.g.ts_install or {}
      local ts_filetypes = vim
        .iter(ts_install)
        :map(function(lang)
          return vim.treesitter.language.get_filetypes(lang)
        end)
        :flatten()
        :totable()

      nvim_ts.install(ts_install)

      vim.api.nvim_create_autocmd('FileType', {
        desc = 'Setup treesitter for a buffer',
        -- NOTE: We explicitly define filetypes
        pattern = ts_filetypes,
        group = vim.api.nvim_create_augroup('ts_setup', { clear = true }),
        callback = function(e)
          vim.treesitter.start(e.buf)
          -- vim.wo.foldmethod = 'expr'
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'html', 'javascriptreact', 'typescriptreact' },
    opts = {},
  },
}
