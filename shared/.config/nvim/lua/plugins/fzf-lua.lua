return {
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'echasnovski/mini.nvim' },
    config = function()
      require('fzf-lua').setup {
        'fzf-tmux',
        defaults = {
          file_icons = 'mini',
        },
        grep = {
          prompt = 'grep > ',
          hidden = true,
        },
        oldfiles = {
          prompt = 'Recents > ',
          cwd_only = true,
        },
        buffers = {
          prompt = 'Buffers > ',
          formatter = 'path.filename_first', -- places file name first
        },
        lsp = {
          prompt_postfix = ' > ',
          cwd_only = true,
        },
        diagnostics = {
          prompt = 'Diagnostics > ',
        },
      }
      local fzf_lua = require 'fzf-lua'
      -- Meta
      vim.keymap.set('n', '<leader><leader>', fzf_lua.global, { desc = 'Search all (fzf global)' })
      vim.keymap.set('n', '<leader>ss', fzf_lua.builtin, { desc = '[S]earch [S]elect picker' })
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
      vim.keymap.set('n', '<leader>sG', function()
        fzf_lua.live_grep { resume = true }
      end, { desc = '[S]earch by [G]rep, resume' })
      vim.keymap.set('n', '<leader>sw', fzf_lua.grep_cword, { desc = '[S]earch current [w]ord' })
      vim.keymap.set('n', '<leader>sW', fzf_lua.grep_cWORD, { desc = '[S]earch current [W]ORD' })
      vim.keymap.set('n', '<leader>/', fzf_lua.lgrep_curbuf, { desc = 'Fuzzy search in current buffer' })

      -- Diagnostics
      vim.keymap.set('n', '<leader>sd', fzf_lua.diagnostics_document, { desc = '[S]earch document [D]iagnostics' })
      vim.keymap.set('n', '<leader>sD', fzf_lua.diagnostics_workspace, { desc = '[S]earch workspace [D]iagnostics' })

      -- Visual
      vim.keymap.set('v', '<leader>sg', fzf_lua.grep_visual, { desc = '[S]earch by [G]rep (visual selection)' })

      -- Notifications
      vim.keymap.set('n', '<leader>sn', function()
        require('fzf-lua').fzf_exec(function(fzf_cb)
          local history = require('fidget.notification').get_history()
          for _, item in ipairs(history) do
            fzf_cb(item.message)
          end
          fzf_cb()
        end, {
          prompt = 'Notifications > ',
          exec_empty_query = true,
        })
      end)
    end,
  },
}
