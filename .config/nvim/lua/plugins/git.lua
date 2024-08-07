return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"FabijanZulj/blame.nvim",
		config = function()
			require("blame").setup()

			vim.api.nvim_set_keymap("n", "<leader>gb", ":BlameToggle virtual<CR>", {})
		end,
	},
}
