return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  event = 'VeryLazy',
  opts = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
    },
  },
  config = function(_, opts)
    require('nvim-treesitter-textobjects').setup(opts)

    local move = require 'nvim-treesitter-textobjects.move'

    vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
      move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Start of next [f]unction' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']F', function()
      move.goto_next_end('@function.outer', 'textobjects')
    end, { desc = 'End of next [F]unction' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
      move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Start of previous [f]unction' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[F', function()
      move.goto_previous_end('@function.outer', 'textobjects')
    end, { desc = 'End of previous [F]unction' })

    vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
      move.goto_next_start('@class.outer', 'textobjects')
    end, { desc = 'Start of next [c]lass' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
      move.goto_next_end('@class.outer', 'textobjects')
    end, { desc = 'End of next [C]lass' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
      move.goto_previous_start('@class.outer', 'textobjects')
    end, { desc = 'Start of previous [c]lass' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
      move.goto_previous_end('@class.outer', 'textobjects')
    end, { desc = 'End of previous [C]lass' })

    vim.keymap.set({ 'n', 'x', 'o' }, ']p', function()
      move.goto_next_start('@parameter.inner', 'textobjects')
    end, { desc = 'Start of next [p]arameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, ']P', function()
      move.goto_next_end('@parameter.inner', 'textobjects')
    end, { desc = 'End of next [P]arameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[p', function()
      move.goto_previous_start('@parameter.inner', 'textobjects')
    end, { desc = 'Start of previous [p]arameter' })
    vim.keymap.set({ 'n', 'x', 'o' }, '[P', function()
      move.goto_previous_end('@parameter.inner', 'textobjects')
    end, { desc = 'End of previous [P]arameter' })

    local select = require 'nvim-treesitter-textobjects.select'

    vim.keymap.set({ 'x', 'o' }, 'af', function()
      select.select_textobject('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      select.select_textobject('@function.inner', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      select.select_textobject('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      select.select_textobject('@class.inner', 'textobjects')
    end)
  end,
}
