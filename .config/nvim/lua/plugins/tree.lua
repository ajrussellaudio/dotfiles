-- return {
-- 	"nvim-tree/nvim-tree.lua",
-- 	config = function()
-- 		require("nvim-tree").setup()
-- 		vim.keymap.set("n", "<leader>n", ":NvimTreeFocus<CR>")
-- 	end,
-- }

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	filesystem = {
		use_libuv_file_watcher = true,
	},
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")
		vim.keymap.set("n", "<leader>gs", ":Neotree git_status reveal float<CR>")
		vim.keymap.set("n", "<leader>b", ":Neotree buffers reveal left<CR>")
	end,
}
