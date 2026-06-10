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

-- Toggle LSP inlay hints for the current buffer
map("n", "<leader>ih", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = buf }, { bufnr = buf })
end, { desc = "Toggle inlay hints" })

-- DAP (Debugging)
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })

map("n", "<leader>dc", function()
  -- Rust-Sessions startet rustaceanvim (baut + konfiguriert codelldb korrekt);
  -- läuft schon eine Session oder ist es eine andere Sprache -> normales continue.
  if vim.bo.filetype == "rust" and not require("dap").session() then
    vim.cmd.RustLsp "debuggables"
  else
    require("dap").continue()
  end
end, { desc = "Debug: Continue / Start" })

map("n", "<leader>dn", function()
  require("dap").step_over()
end, { desc = "Debug: Step Over (Next)" })

map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug: Step Into" })

map("n", "<leader>dx", function()
  require("dap").terminate()
end, { desc = "Debug: Terminate" })

-- Wert unter Cursor (oder markierten Ausdruck) in Float-Fenster anzeigen
map({ "n", "v" }, "<leader>de", function()
  require("dapui").eval()
end, { desc = "Debug: Eval (Variable unter Cursor)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
