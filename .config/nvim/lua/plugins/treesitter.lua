return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				-- neovim
				"lua",
				"regex",
				"markdown",
				"markdown_inline",

				-- web dev
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			context_commentstring = {
				config = {
					javascript = {
						__default = "// %s",
						jsx_element = "{/* %s */}",
						jsx_fragment = "{/* %s */}",
						jsx_attribute = "// %s",
						comment = "// %s",
					},
					typescript = { __default = "// %s", __multiline = "/* %s */" },
				},
			},
		})

		vim.filetype.add({
			filename = {},
			pattern = {
				["Dockerfile.*"] = "dockerfile",
				["*.docker"] = "dockerfile",
				[".*/hypr/.*%.conf"] = "hyprlang",
			},
		})

        -- vim.treesitter.language.register("<tree-sitter>", "<filetype>")
		vim.treesitter.language.register("dockerfile", "docker")
	end,
}
