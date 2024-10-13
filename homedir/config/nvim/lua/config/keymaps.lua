-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Tmux key maps
-- https://github.com/christoomey/vim-tmux-navigator/issues/295#issuecomment-2277866241
local map = LazyVim.safe_keymap_set

map("n", "<C-l>", "<Cmd>NvimTmuxNavigateRight<CR>")
map("n", "<C-h>", "<Cmd>NvimTmuxNavigateLeft<CR>")
map("n", "<C-k>", "<Cmd>NvimTmuxNavigateUp<CR>")
map("n", "<C-j>", "<Cmd>NvimTmuxNavigateDown<CR>")
