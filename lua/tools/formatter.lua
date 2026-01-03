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

