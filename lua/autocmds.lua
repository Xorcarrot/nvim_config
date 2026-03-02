require "nvchad.autocmds"

vim.filetype.add {
  extension = {
    tsx = "typescriptreact",
    jsx = "javascriptreact",
  },
  filename = {
    ["docker-compose.yml"] = "yaml",
    ["docker-compose.yaml"] = "yaml",
  },
  pattern = {
    ["docker%-compose%.ya?ml"] = "yaml",
  },
}
