-- Visual guide to block scope and indentation
return {
  'nvim-mini/mini.indentscope',
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('mini.indentscope').setup {
      symbol = '┆',
    }
  end,
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
