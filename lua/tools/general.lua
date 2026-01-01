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
}
