return {
	{
		-- Shows scope of current indent level
		"echasnovski/mini.indentscope",
		version = "*",
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		-- Status bar at bottom of current window
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff" },
					lualine_c = { "diagnostics" },
					lualine_x = { "filetype" },
					lualine_y = { "location" },
					lualine_z = { "buffers" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
			})
		end,
	},
}
