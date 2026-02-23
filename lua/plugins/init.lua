return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      -- settings to format
      formatters_by_ft = {
        lua = { "stylua" },

        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },

        rust = { "rustfmt" },
      },

      -- formatting trigger
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    },
  },

  -- Language Server
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- Syntax Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPost", -- Lädt es, sobald du eine Datei öffnest
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "angular", -- WICHTIG für Angular Templates!
        "rust",
        "scss",
        "dockerfile",
        "yaml",
      },
      highlight = {
        enable = true, -- Aktiviert das bessere Highlighting
      },
      indent = {
        enable = true, -- Aktiviert die bessere Einrückung
      },
    },
  },

  {
    "github/copilot.vim",
    lazy = false,
    config = function() end,
  },
}
