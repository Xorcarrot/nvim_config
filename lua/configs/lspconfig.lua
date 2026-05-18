local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

-- Only "simple" servers in the loop (no special cmd/filetypes)
local servers = {
  "html",
  "cssls",
  "ts_ls",
  "rust_analyzer",
  "tailwindcss",
  "dockerls",
  "clangd", -- C/C++
}

for _, lsp in ipairs(servers) do
  if vim.fn.has "nvim-0.11" == 1 then
    vim.lsp.config[lsp] = {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
    vim.lsp.enable(lsp)
  else
    lspconfig[lsp].setup {
      on_attach = on_attach,
      on_init = on_init,
      capabilities = capabilities,
    }
  end
end

-- angular language server (special case: needs explicit ngserver cmd + filetypes)
local angular_cfg = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    vim.fn.getcwd(),
    "--ngProbeLocations",
    vim.fn.getcwd(),
  },
  filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
}

-- docker-compose language server (special case: needs stdio + explicit filetypes)
local compose_cfg = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "docker-compose-langserver", "--stdio" },
  filetypes = { "yaml" },
}

if vim.fn.has "nvim-0.11" == 1 then
  vim.lsp.config.angularls = angular_cfg
  vim.lsp.enable "angularls"
  vim.lsp.config.docker_compose_language_service = compose_cfg
  vim.lsp.enable "docker_compose_language_service"
else
  lspconfig.angularls.setup(angular_cfg)
  lspconfig.docker_compose_language_service.setup(compose_cfg)
end
