return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", false },
      { "S", false },
      {
        "<leader>z",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>Z",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
}
