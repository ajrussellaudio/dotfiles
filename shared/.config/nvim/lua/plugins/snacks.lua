return {
  {
    'folke/snacks.nvim',
    dependencies = {
      {
        'folke/persistence.nvim',
        event = 'BufReadPre', -- this will only start session saving when an actual file was opened
        opts = {
          -- add any custom options here
        },
      },
    },
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = '.', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = '󰁯 ', key = 's', desc = 'Restore Session', section = 'session' },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = '󱌢 ', key = 'm', desc = 'Mason', action = ':Mason' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
        sections = {
          {
            section = 'terminal',
            cmd = 'stormy',
            hl = 'header',
            indent = 10,
          },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'recent_files', cwd = true, padding = 1 },
          { section = 'startup' },
        },
      },
    },
  },
}
