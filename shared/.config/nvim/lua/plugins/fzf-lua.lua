return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup {
        'fzf-tmux',
        grep = {
          prompt = 'grep > ',
          hidden = true,
        },
        oldfiles = {
          prompt = 'Recents > ',
          cwd_only = true,
        },
      }
      local fzf_lua = require 'fzf-lua'
      -- Meta
      vim.keymap.set('n', '<leader><leader>', fzf_lua.global, { desc = 'Search all (fzf global)' })
      vim.keymap.set('n', '<leader>ss', fzf_lua.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sr', fzf_lua.resume, { desc = '[S]earch [R]esume' })

      -- Neovim
      vim.keymap.set('n', '<leader>sh', fzf_lua.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf_lua.keymaps, { desc = '[S]earch [K]eymaps' })

      -- Files
      vim.keymap.set('n', '<leader>sf', fzf_lua.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sb', fzf_lua.buffers, { desc = '[S]earch [B]uffers' })
      vim.keymap.set('n', '<leader>s.', fzf_lua.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader>s!', function()
        fzf_lua.oldfiles {
          prompt = 'All Recents > ',
          cwd_only = false,
        }
      end, { desc = '[S]earch Recent Files (everywhere)' })

      -- grep
      vim.keymap.set('n', '<leader>sg', fzf_lua.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sw', fzf_lua.grep_cword, { desc = '[S]earch current [w]ord' })
      vim.keymap.set('n', '<leader>sW', fzf_lua.grep_cWORD, { desc = '[S]earch current [W]ORD' })
      vim.keymap.set('n', '<leader>/', fzf_lua.lgrep_curbuf, { desc = 'Fuzzy search in current buffer' })

      -- Diagnostics
      vim.keymap.set('n', '<leader>sd', fzf_lua.diagnostics_document, { desc = '[S]earch document [D]iagnostics' })
      vim.keymap.set('n', '<leader>sD', fzf_lua.diagnostics_workspace, { desc = '[S]earch workspace [D]iagnostics' })

      -- Visual
      vim.keymap.set('v', '<leader>sg', fzf_lua.grep_visual, { desc = '[S]earch by [G]rep (visual selection)' })
    end,
  },
}
