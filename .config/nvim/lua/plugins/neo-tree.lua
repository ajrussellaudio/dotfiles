return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/1253#discussioncomment-8163887
		-- Get the commands module from neo-tree.sources.filesystem. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/sources/filesystem/commands.lua
		require("neo-tree.sources.filesystem.commands")
			-- Call the refresh function found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/filesystem/commands.lua#L11-L13
			.refresh(
				-- Pull in the manager module. Found here: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/2f2d08894bbc679d4d181604c16bb7079f646384/lua/neo-tree/sources/manager.lua
				require("neo-tree.sources.manager")
					-- Fetch the state of the "filesystem" source, feeding it to the filesystem refresh call since most everything in neo-tree
					-- expects to get its state fed to it
					.get_state("filesystem")
			)
		vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>")
		vim.keymap.set("n", "<leader>gs", ":Neotree git_status reveal float<CR>")
	end,
}
