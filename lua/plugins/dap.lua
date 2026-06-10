return {
  -- Debug Adapter Protocol: Kern-Engine + UI in einem Spec, damit beim ersten
  -- require("dap") (aus den Keymaps) auch dap-ui mitgeladen wird und seine
  -- Auto-Open-Listener registriert sind, BEVOR eine Session startet.
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- Pflicht-Abhängigkeit von dap-ui
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      ----------------------------------------------------------------------
      -- Rust: Adapter UND Configuration kommen komplett von rustaceanvim.
      ----------------------------------------------------------------------
      -- Hier bewusst KEIN dap.adapters.codelldb registrieren: rustaceanvim
      -- legt nur dann seinen eigenen (Mason-codelldb mit korrektem --liblldb)
      -- an, wenn der Key noch frei ist — ein manueller Eintrag würde ihn
      -- verdecken. Rust debuggen über  :RustLsp debuggables  (siehe <leader>dc),
      -- nicht über dap.continue() mit einer handgepflegten Config.
      -- Für C/C++-Debugging müsste man hier wieder einen codelldb-Adapter
      -- plus dap.configurations.c/cpp anlegen.

      ----------------------------------------------------------------------
      -- UI + Auto-Open/Close-Listener (hier registriert, damit sie sicher
      -- stehen, sobald dap geladen ist)
      ----------------------------------------------------------------------
      dapui.setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  -- Rust: automatisches DAP-Setup + erweiterte LSP-Features (ersetzt rust_analyzer via lspconfig)
  {
    "mrcjkb/rustaceanvim",
    -- ^8 ist die letzte Major-Reihe für Neovim 0.11 (v9 verlangt 0.12).
    -- NICHT auf ^4 zurückpinnen: 4.26.1 (Juli 2024) ist zu alt für
    -- rust-analyzer/Neovim von 2026 und nutzt entfernte/deprecated APIs.
    version = "^8",
    -- Upstream-Empfehlung: kein ft/event-Lazy-Loading — das Plugin ist
    -- intern bereits lazy und braucht sein ftplugin beim ersten Rust-Buffer.
    lazy = false,
  },
}
