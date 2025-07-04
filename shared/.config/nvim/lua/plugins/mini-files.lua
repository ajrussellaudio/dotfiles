return {
  "echasnovski/mini.files",
  opts = {
    options = {
      use_as_default_explorer = false,
    },
  },
  keys = {
    {
      "<leader>-",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (Directory of Current File)",
    },
    {
      "<leader>_",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
  },
}
