local options = {
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },

    -- Web / Angular (Prettier)
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },

    -- C / C++
    c = { "clang-format" }, -- Beachte den Bindestrich statt Unterstrich (Standardname)
    cpp = { "clang-format" },

    -- Rust
    rust = { "rustfmt" },

    -- Other Stuff
    dosbatch = { "beautysh" },
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
