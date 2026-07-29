return {
  'juacker/git-link.nvim',
  keys = {
    {
      '<leader>gu',
      function()
        require('git-link.main').copy_line_url()
      end,
      desc = 'Copy code link to clipboard',
      mode = { 'n', 'x' },
    },
    {
      '<leader>go',
      function()
        require('git-link.main').open_line_url()
      end,
      desc = 'Open code link in browser',
      mode = { 'n', 'x' },
    },
    {
      '<leader>gp',
      function()
        require('git-link.main').copy_permalink()
      end,
      desc = 'Copy code permalink to clipboard',
      mode = { 'n', 'x' },
    },
    {
      '<leader>gP',
      function()
        require('git-link.main').open_permalink()
      end,
      desc = 'Open code permalink in browser',
      mode = { 'n', 'x' },
    },
  },
}
