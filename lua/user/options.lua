-- clipboard must be installed manulae: wl-clipboard x-clip
vim.opt.clipboard = "unnamedplus"
lvim.format_on_save.enabled = true


-- 2. TypeScript konfigurieren
-- Wir müssen dem Server explizit sagen, dass wir ALLE Hints wollen.
-- (Rust Analyzer macht das meistens von alleine, TS nicht).
require("lvim.lsp.manager").setup("ts_ls", {
  init_options = {
    preferences = {
      -- Hier schalten wir alles an:
      includeInlayParameterNameHints = "all", -- Zeigt Parameternamen (z.B. "text:")
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true, -- Zeigt Typen in Funktionen
      includeInlayVariableTypeHints = true,          -- Zeigt Typen bei Variablen
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true, -- Zeigt Rückgabetypen
      includeInlayEnumMemberValueHints = true,
    },
  },
})
