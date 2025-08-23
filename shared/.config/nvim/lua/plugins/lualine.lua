return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'snacks_dashboard' },
        },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str)
              return str:sub(1, 1)
            end,
          },
        },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'diagnostics',
          },
          {
            'filename',
            color = function()
              return vim.bo.modified and 'WarningMsg' or nil
            end,
            path = 4,
          },
        },
        lualine_x = { 'filetype', 'lsp_status' },
        lualine_y = { 'searchcount' },
        lualine_z = { 'location' },
      },
    },
  },
}
