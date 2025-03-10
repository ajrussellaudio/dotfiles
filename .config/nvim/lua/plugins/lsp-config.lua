return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"eslint",
					"emmet_language_server",
					"stylelint_lsp",
				},
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(_, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			lspconfig.emmet_language_server.setup({
				capabilities = capabilities,
			})

			lspconfig.stylelint_lsp.setup({
				filetypes = { "css", "scss" },
				root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
				settings = {
					stylelintplus = {
						-- see available options in stylelint-lsp documentation
					},
				},
				on_attach = function(client)
					client.server_capabilities.document_formatting = false
				end,
			})

			-- globals
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
					-- vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					-- vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					-- vim.keymap.set("n", "<leader>wl", function()
					-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					-- end, opts)
					-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("i", "jj", vim.lsp.buf.references, opts)
				end,
			})
		end,
	},
}
