local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

local servers = {
  "html",
  "cssls",
  "ts_ls",
  "angularls",
  "rust_analyzer",
  "tailwindcss",
  "docker_ls",
  "docker_compose_language_service",
}

for _, lsp in ipairs(servers) do
  -- Prüfen, ob wir auf Neovim 0.11+ sind (wo der Fehler auftritt)
  if vim.fn.has "nvim-0.11" == 1 then
    -- === NEUER WEG (Nvim 0.11+) ===
    -- Wir schreiben die Config direkt in die Vim-Interne Tabelle
    vim.lsp.config[lsp] = {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
    -- Server global aktivieren
    vim.lsp.enable(lsp)
  else
    -- === ALTER WEG (Nvim 0.10 und älter) ===
    -- Fallback, damit es auch auf Stable-Versionen läuft
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end
end
