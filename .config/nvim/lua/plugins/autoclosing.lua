return {
	{
    -- closes brackets
		"m4xshen/autoclose.nvim",
		config = function()
			require("autoclose").setup()
		end,
	},
  {
    -- closes HTML
    "windwp/nvim-ts-autotag",
    config = function ()
      require('nvim-ts-autotag').setup({
        enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
      })
    end
  }
}
