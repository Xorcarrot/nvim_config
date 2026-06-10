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
      -- codelldb-Adapter (C / C++ und – via rustaceanvim – Rust)
      ----------------------------------------------------------------------
      -- Adapter bleibt registriert: rustaceanvim findet ihn hierüber bzw. über
      -- den Mason-Pfad und nutzt ihn für sein Rust-DAP-Setup.
      -- Rust-CONFIGURATION bewusst NICHT hier definieren: rustaceanvim baut sie
      -- selbst (korrektes Sysroot, cargo-Build, passende codelldb-Settings).
      -- Rust debuggen daher über  :RustLsp debuggables  starten, nicht über
      -- dap.continue() mit einer handgepflegten Config.
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      ----------------------------------------------------------------------
      -- Angular / TypeScript / JavaScript  ->  js-debug-adapter (pwa-node)
      ----------------------------------------------------------------------
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath "data" .. "/mason/bin/js-debug-adapter",
          args = { "${port}" },
        },
      }

      dap.configurations.typescript = {
        {
          name = "Attach to Chrome (Angular, Port 9222)",
          type = "pwa-node",
          request = "attach",
          port = 9222,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        },
      }
      dap.configurations.javascript = dap.configurations.typescript

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
    version = "^4",
    ft = { "rust" },
  },
}
