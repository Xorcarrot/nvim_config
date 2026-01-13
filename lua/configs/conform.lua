local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Web / Angular (Prettier)
    html = { "prettier" },
    css = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },

    -- Rust
    rust = { "rustfmt" },
  },

  -- Autosave aktivieren
  format_on_save = {
    -- Timeout in Millisekunden (Zeit, die er wartet bevor er aufgibt)
    timeout_ms = 500,
    -- Falls kein expliziter Formatter (wie Prettier) da ist, nutze den LSP
    lsp_fallback = true,
  },
}

return options
