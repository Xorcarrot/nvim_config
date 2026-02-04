require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Rsizing Commands
map("n", "<C-right>", [[<cmd>vertical resize +5<cr>]])
map("n", "<C-left>", [[<cmd>vertical resize -5<cr>]])
map("n", "<C-up>", [[<cmd>horizontal resize +2<cr>]])
map("n", "<C-down>", [[<cmd>horizontal resize -2<cr>]])

-- Terminal toggeln
map({ "n", "t" }, "<F1>", function()
  require("nvchad.term").toggle { pos = "sp", id = "floatTerm" }
end, { desc = "Toggle Floating Terminal" })

-- Terminal (Normal Mode)
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
