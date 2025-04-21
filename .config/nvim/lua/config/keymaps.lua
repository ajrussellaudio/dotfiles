-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://www.reddit.com/r/neovim/s/ijMNrMACqz
vim.keymap.set("n", "ycc", "yygccp", { remap = true, desc = "Duplicate and comment line" })
