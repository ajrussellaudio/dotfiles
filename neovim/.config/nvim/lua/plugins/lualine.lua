return {
  'nvim-lualine/lualine.nvim',
  -- Adapted from:
  -- https://github.com/catppuccin/tmux/discussions/317#discussioncomment-14030975
  opts = function(_, opts)
    local auto = require 'lualine.themes.auto'

    local colors = require('catppuccin.palettes').get_palette 'mocha'

    local function separator()
      return {
        function()
          return '│'
        end,
        color = { fg = colors.surface0, bg = 'NONE', gui = 'bold' },
        padding = { left = 0, right = 0 },
      }
    end

    local function custom_branch()
      local gitsigns = vim.b.gitsigns_head
      local fugitive = vim.fn.exists '*FugitiveHead' == 1 and vim.fn.FugitiveHead() or ''
      local branch = gitsigns or fugitive
      if branch == nil or branch == '' then
        return ''
      else
        return ' ' .. branch
      end
    end

    local modes = { 'normal', 'insert', 'visual', 'replace', 'command', 'inactive', 'terminal' }
    for _, mode in ipairs(modes) do
      if auto[mode] and auto[mode].c then
        auto[mode].c.bg = 'NONE'
      end
    end

    opts.options = vim.tbl_deep_extend('force', opts.options or {}, {
      theme = auto,
      component_separators = '',
      section_separators = '',
      globalstatus = true,
    })

    opts.sections = {
      lualine_a = {
        {
          'mode',
          fmt = function(str)
            return str:sub(1, 1)
          end,
          padding = { left = 1, right = 1 },
        },
      },
      lualine_b = {
        {
          custom_branch,
          color = { fg = colors.green, bg = 'none' },
          padding = { left = 1, right = 1 },
        },
        {
          'diff',
          colored = true,
          diff_color = {
            added = { fg = colors.teal, bg = 'none', gui = 'bold' },
            modified = { fg = colors.yellow, bg = 'none', gui = 'bold' },
            removed = { fg = colors.red, bg = 'none', gui = 'bold' },
          },
          source = nil,
          padding = { left = 0, right = 1 },
        },
        separator(),
      },
      lualine_c = {
        {
          'filename',
          file_status = true,
          path = 1,
          shorting_target = 20,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '[?]',
            newfile = '[!]',
          },
          color = { fg = colors.blue, bg = 'none' },
          padding = { left = 1, right = 1 },
        },
        {
          'diagnostics',
          sources = { 'nvim_diagnostic' },
          sections = { 'error', 'warn', 'info', 'hint' },
          diagnostics_color = {
            error = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              return { fg = (count == 0) and colors.green or colors.red, bg = 'none', gui = 'bold' }
            end,
            warn = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              return { fg = (count == 0) and colors.green or colors.yellow, bg = 'none', gui = 'bold' }
            end,
            info = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
              return { fg = (count == 0) and colors.green or colors.blue, bg = 'none', gui = 'bold' }
            end,
            hint = function()
              local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
              return { fg = (count == 0) and colors.green or colors.teal, bg = 'none', gui = 'bold' }
            end,
          },
          symbols = {
            error = '󰅚 ',
            warn = '󰀪 ',
            info = '󰋽 ',
            hint = '󰌶 ',
          },
          colored = true,
          update_in_insert = false,
          always_visible = false,
          padding = { left = 0, right = 1 },
        },
      },
      lualine_x = {
        {
          function()
            local bufnr_list = vim.fn.getbufinfo { buflisted = 1 }
            local total = #bufnr_list
            local current_bufnr = vim.api.nvim_get_current_buf()
            local current_index = 0

            for i, buf in ipairs(bufnr_list) do
              if buf.bufnr == current_bufnr then
                current_index = i
                break
              end
            end

            return string.format(' %d/%d', current_index, total)
          end,
          color = { fg = colors.yellow, bg = 'none' },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_y = {
        separator(),
        {
          'filetype',
          icon_only = true,
          colored = false,
          color = { fg = colors.blue, bg = 'none' },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_z = {
        separator(),
        {
          'location',
          color = { fg = colors.red, bg = 'none' },
          padding = { left = 1, right = 1 },
        },
      },
    }

    local dash_cwd = {
      sections = {
        lualine_y = {
          function()
            local session_root = vim.fn.environ()['TMUXIFIER_SESSION_ROOT']
            local cwd = vim.fn.getcwd()
            local local_cwd = vim.fn.fnamemodify(cwd, ':s?' .. session_root .. '?.?')
            return local_cwd
          end,
        },
      },
      filetypes = { 'snacks_dashboard' },
    }
    opts.extensions = { dash_cwd }

    return opts
  end,
}
