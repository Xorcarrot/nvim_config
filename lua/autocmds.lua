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

-- Angular HTML templates get filetype `htmlangular` (set by nvim-lspconfig when an
-- Angular project is detected), but the tree-sitter parser is registered under the
-- name `angular`. Map them so highlighting attaches.
vim.treesitter.language.register("angular", "htmlangular")

-- Force htmlangular filetype for any .html file inside an Angular project (detected
-- by presence of angular.json walking up from the file). Built-in detection misses
-- non-*.component.html templates and inline-style file layouts.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.html",
  callback = function(args)
    if vim.bo[args.buf].filetype == "htmlangular" then
      return
    end
    local found = vim.fs.find("angular.json", {
      upward = true,
      path = vim.fs.dirname(args.file),
      stop = vim.uv.os_homedir(),
    })
    if #found > 0 then
      vim.bo[args.buf].filetype = "htmlangular"
    end
  end,
})
