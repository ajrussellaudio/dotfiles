-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://www.reddit.com/r/neovim/s/ijMNrMACqz
vim.keymap.set("n", "ycc", "yygccp", { remap = true, desc = "Duplicate and comment line" })

-- Terraform alignment
vim.keymap.set(
  { "v" },
  "<leader>=",
  "!sed 's/=/PXXXQYYY/'| column -t -s 'PXXX' | sed 's/QYYY\\s*/= /' | sed 's/  = /=/'<CR>",
  { desc = "Align to = char" }
)
vim.keymap.set({ "v" }, "<leader>+", ":s/ \\+= / = /g<CR>", { desc = "Remove = char alignment" })

-- CodeCompanion
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
