return {
  'ChickenPaella/nvim-pets',
  dependencies = {
    {
      -- image.nvim: the rendering backend. Required, and must be set up.
      '3rd/image.nvim',
      event = 'VeryLazy',
      opts = {
        processor = 'magick_cli', -- uses the ImageMagick CLI (brew install imagemagick)
        backend = 'kitty', -- Kitty Graphics Protocol
      },
    },
  },
  -- `cmd` matters: with only `keys`, the plugin stays unloaded until you
  -- press one of them, so typing `:Pets` first fails with "Not an editor
  -- command". Listing the commands lets them load it too.
  cmd = {
    'Pets',
    'PetsHelp',
    'PetsState',
    'PetsStatus',
    'PetsThrow',
    'PetsFeed',
    'PetsPomodoro',
    'PetsType',
    'PetsCount',
    'PetsResize',
    'PetsArea',
    'PetsMove',
  },
  keys = {
    { '<leader>pp', '<cmd>Pets<cr>', desc = 'Pets: toggle' },
    { '<leader>pf', '<cmd>PetsFeed<cr>', desc = 'Pets: feed' },
    { '<leader>pb', '<cmd>PetsThrow<cr>', desc = 'Pets: throw (ball)' },
  },
  config = function()
    require('pets').setup {
      -- All optional; values shown are the defaults.
      pet = 'panda', -- "fox" | "panda" | "dog" | "turtle"
      count = 1, -- how many pets roam at once (1-6)
      settle_ms = 1200, -- freeze the pets after this idle time (0 = never)
      -- width / height default to the species' own cell size (fox is 7x3),
      -- not to any fixed number. Set them only to override that.
      width = 7,
      height = 3,
      fps = 6,
      area = {
        corner = 'br', -- "br" | "bl" | "tr" | "tl"
        cols = 0, -- 0 = auto: cover most of the editor width
        rows = 0, -- 0 = auto: cover most of the editor height
      },
    }
  end,
}
