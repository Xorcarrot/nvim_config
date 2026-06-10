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

  -- LaTeX
  {
    "lervag/vimtex",
    lazy = false, -- VimTeX empfiehlt, nicht lazy zu laden
    init = function()
      -- latexmk ist Standard; schreibt foo.pdf direkt neben foo.tex (wird bei jedem Build überschrieben)
      vim.g.vimtex_compiler_method = "latexmk"

      -- Headless/SSH: kein lokaler Viewer. PDF landet im synchronisierten Ordner (Google Drive).
      -- view_method nur relevant falls man je \lv lokal/per X-Forwarding aufruft.
      vim.g.vimtex_view_method = "zathura"

      -- Verhindert, dass sich nach Fehlern nervige Quickfix-Fenster ungewollt öffnen
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
}
