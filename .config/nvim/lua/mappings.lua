-- Load NvChad’s default mappings
require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<C-o>", "<cmd>Telescope find_files<CR>", { desc = "Telescope find files" })
map("n", "<C-p>", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep" })
