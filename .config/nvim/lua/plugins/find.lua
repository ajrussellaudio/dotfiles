return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- calling `setup` is optional for customization
			require("fzf-lua").setup({})

			vim.api.nvim_set_keymap("n", "<leader>fb", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>fk", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>ff", [[<Cmd>lua require"fzf-lua".files()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>fl", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>fg", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>fd", [[<Cmd>lua require"fzf-lua".diagnostics_document()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>fD", [[<Cmd>lua require"fzf-lua".diagnostics_workspace()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<leader>ca", [[<Cmd>lua require"fzf-lua".lsp_code_actions()<CR>]], {})
			vim.api.nvim_set_keymap("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})
		end,
	},
}
