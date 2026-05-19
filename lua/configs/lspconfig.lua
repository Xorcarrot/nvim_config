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

-- ts_ls and rust_analyzer need explicit settings to emit inlay hints (clangd
-- emits them out of the box; the others in this list don't support them).
local ts_inlay = {
  includeInlayParameterNameHints = "literals",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local server_settings = {
  ts_ls = {
    settings = {
      typescript = { inlayHints = ts_inlay },
      javascript = { inlayHints = ts_inlay },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        inlayHints = {
          bindingModeHints = { enable = false },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true, minLines = 25 },
          closureReturnTypeHints = { enable = "never" },
          lifetimeElisionHints = { enable = "never", useParameterNames = false },
          maxLength = 25,
          parameterHints = { enable = true },
          reborrowHints = { enable = "never" },
          renderColons = true,
          typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
        },
      },
    },
  },
}

for _, lsp in ipairs(servers) do
  local cfg = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }, server_settings[lsp] or {})

  if vim.fn.has "nvim-0.11" == 1 then
    vim.lsp.config[lsp] = cfg
    vim.lsp.enable(lsp)
  else
    lspconfig[lsp].setup(cfg)
  end
end

-- angular language server: only override attach hooks. Upstream lsp/angularls.lua
-- already computes correct ngserver probe paths from node_modules and ships the
-- right filetypes (typescript, html, htmlangular, typescriptreact) plus
-- root_markers (angular.json, nx.json). Overriding cmd here broke probe resolution.
local angular_cfg = {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
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
