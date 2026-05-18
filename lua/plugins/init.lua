return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function()
      return require "configs.conform"
    end,
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
    branch = "master", -- NvChad v2.5 + this config use the legacy nvim-treesitter API.
    -- Upstream switched the default branch to `main` (a full rewrite), which has no
    -- `nvim-treesitter.configs.setup`, ignores `ensure_installed`, and breaks
    -- `:TSUpdate`/`:TSInstall` here. Pin to master until NvChad ships main-branch support.
    event = "BufReadPost", -- Lädt es, sobald du eine Datei öffnest
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "batch",
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
