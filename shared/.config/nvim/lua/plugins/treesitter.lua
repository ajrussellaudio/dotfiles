local ensure_installed = {
  -- JavaScript
  'javascript',
  'javascriptreact',
  'json',
  'jsx',
  'typescript',
  'typescriptreact',
  'tsx',
  'astro',

  -- Other web dev
  'css',
  'html',
  'groq', -- best parser ever
  'regex',

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
  'gitconfig',
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
      nvim_ts.install(ensure_installed)

      local ts_start_group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = ts_start_group,
        pattern = ensure_installed,
        callback = function(event)
          vim.treesitter.start()
          vim.notify('Treesitter started: ' .. event.match)
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
