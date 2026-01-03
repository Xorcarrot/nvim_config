lvim.plugins = {

  -- Github Copilot
  -- Setup with Command "Copilot auth"
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestions = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-a>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          help = true,
        },
      })
    end,
  },

  -- show colors inline
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "html",
        "javascript",
        "typescript",
        "typescriptreact"
      }, {
        mode = "background",
        tailwind = true,
      })
    end,
  },

  -- Syntax Highlight for Angular
  { "nvim-treesitter/nvim-treesitter-angular" },

  {
    "stevearc/conform.nvim",
    config = function()
      local conform = require("conform")

      conform.setup({
        -- Hier definierst du, welcher Formatter für welche Datei
        formatters_by_ft = {
          lua = { "stylua" },
          -- Web Dev (Prettier)
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          -- Python (Black)
          python = { "black" },
          -- Rust (nutzt meistens den LSP, aber falls du rustfmt erzwingen willst)
          rust = { "rustfmt" },
        },
        
        -- Automatische Formatierung beim Speichern
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true, -- WICHTIG: Wenn kein Formatter da ist, nutze den LSP (gut für Rust!)
        },
      })
    end,
  },
}
