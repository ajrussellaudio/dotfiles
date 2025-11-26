-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
return {
  'nvim-mini/mini.ai',
  version = '*',
  event = 'VeryLazy',
  opts = {
    n_lines = 500,
  },
}
