local formatters = require "lvim.lsp.null-ls.formatters"

formatters.setup {
  {
    -- Angular config with prettier
    command = "prettierd",
    filetypes = { 
      "html", 
      "css", 
      "scss", 
      "less", 
      "javascript", 
      "typescript", 
      "typescriptreact",
      "json"
    },
  },

  -- Rust with integrated rustfmt 
  { command = "rustfmt", filetypes = { "rust" } },
}

lvim.lsp.on_attach_callback = function(client, bufnr)
  -- set rust_analyzer
  if client.name == "rust_analyzer" then
    client.server_capabilities.documentFormattingProvider = true
  end

  -- show Ghost Text
  if client.server_capabilities.inlayHintProvider then
    -- Feature für den aktuellen Buffer einschalten
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

