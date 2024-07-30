local opts = { noremap = true, silent = true }
local map = vim.keymap.set

vim.g.mapleader = " "

-- Fast saving
map("n", "<Leader>w", ":write!<CR>", opts)
-- map("n", "<Leader>q", ":q!<CR>", opts)

-- Zoom to search result
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
map("n", "*", "*zz", opts)
map("n", "#", "#zz", opts)
map("n", "g*", "g*zz", opts)
map("n", "g#", "g#zz", opts)

-- Zoom to up and down
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Clear search on Esc
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Copy to system clipboard (Mac only)
map("v", "Y", ":w !pbcopy<CR><CR>")

-- View Nerd Font glyphs
map("n", "<leader>f,", ":Nerdy<CR>")

-- Tab through open buffers
map("n", "<Tab>", ":bnext<CR>")
map("n", "<S-Tab>", ":bprev<CR>")
