local options = {
"stevearc/conform.nvim",
  opts = {
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },

    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },

      c = { "clang-format" },
      cpp = { "clang-format" },

      rust = { "rustfmt" },

      dosbatch = { "beautysh" },
    },
  },
}

return options
