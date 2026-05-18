# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration built on top of **NvChad v2.5** (branch `v2.5`), managed with `lazy.nvim`. Drop the repo at `~/.config/nvim/` and launch `nvim`; lazy.nvim self-bootstraps on first run (see `init.lua`).

## Bootstrap & entrypoint flow

`init.lua` is the single entrypoint and runs in this order:

1. Sets `base46_cache`, `<leader>` = space, `clipboard = unnamedplus` (Neovim picks the provider — `xclip` on this machine).
2. Clones `lazy.nvim` (stable branch) if missing.
3. `lazy.setup` loads `NvChad/NvChad` (`import = "nvchad.plugins"`) **and** any user plugin specs in `lua/plugins/`.
4. `dofile`s the cached base46 highlight files (`defaults`, `statusline`) — these only exist after NvChad has built them, so a fresh clone needs `:Lazy sync` to succeed before colors work.
5. Requires `options`, `autocmds`, and (scheduled) `mappings`. Each of these `require`s the NvChad equivalent first, then layers customizations.

This "require NvChad's version, then add yours" pattern is the convention — keep it when editing `options.lua`, `autocmds.lua`, `mappings.lua`.

## Where to put what

- `lua/chadrc.lua` — NvChad UI config (theme is `bearded-arc`). Schema must match [`nvconfig.lua`](https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua).
- `lua/configs/lazy.lua` — `lazy.nvim` setup opts (defaults `lazy = true`, disabled rtp plugins).
- `lua/configs/lspconfig.lua` — LSP server list and per-server overrides. Loaded by the `nvim-lspconfig` plugin spec.
- `lua/plugins/init.lua` — extra plugin specs (conform, lspconfig, treesitter, copilot).
- `lua/configs/conform.lua` — formatter table (not a plugin spec; consumed via `opts = function() return require "configs.conform" end` from `plugins/init.lua`). Must live outside `lua/plugins/` because `init.lua` does `{ import = "plugins" }`, which would otherwise load this file as a plugin spec and error.
- `lua/mappings.lua`, `lua/options.lua`, `lua/autocmds.lua` — user-level extensions on top of NvChad defaults.

## LSP

`lua/configs/lspconfig.lua` handles **two Neovim API generations** in one file:

- On `nvim-0.11+` it uses the new `vim.lsp.config[name] = {...}` + `vim.lsp.enable(name)` API.
- On older versions it falls back to `lspconfig[name].setup{...}`.

When adding a server, add it to the `servers` table for the simple case. For servers needing per-server overrides (current examples: `angular_cfg`, `compose_cfg` for `docker_compose_language_service`), build the config table and branch on `has("nvim-0.11")` the same way.

Currently enabled in the simple loop: `html`, `cssls`, `ts_ls`, `rust_analyzer`, `tailwindcss`, `dockerls`, `clangd`. Registered separately: `angularls` (attach hooks only; upstream `lsp/angularls.lua` handles cmd/probe paths/filetypes — do NOT override `cmd` here or ngserver will crash with "Failed to resolve '@angular/language-service'") and `docker_compose_language_service` (custom `cmd` + `filetypes`).

## Formatting

`conform.nvim` runs on `BufWritePre` with `format_on_save` (lsp_fallback, 500ms timeout). Mapping in `lua/plugins/conform.lua`:

- `stylua` for lua, `prettier` for web (js/ts/json/html/css/scss), `clang-format` for c/cpp, `rustfmt` for rust, `beautysh` for `dosbatch`.

Lua style is locked by `.stylua.toml`: 2-space indent, 120 col width, double quotes preferred, no parens on single-arg calls.

## Filetype quirks

`lua/autocmds.lua` adds:
- `.tsx` → `typescriptreact`, `.jsx` → `javascriptreact`
- `docker-compose.y(a)ml` → `yaml` (so `docker_compose_language_service` attaches via its `filetypes = { "yaml" }`)
- Any `*.html` inside a project that has an `angular.json` walking up from the file (stops at `$HOME`) is forced to `htmlangular`. Covers `*.component.html` and any other Angular template — built-in nvim filetype detection misses cases.
- `vim.treesitter.language.register("angular", "htmlangular")` — the tree-sitter parser is named `angular` but Angular templates use filetype `htmlangular`. Without this alias, highlighting silently falls back to the html parser (no `@if`/`@for`/`ng-content` highlighting).

## Custom keymaps (in addition to NvChad defaults)

Defined in `lua/mappings.lua`:
- `;` → `:` (normal), `jk` → `<Esc>` (insert)
- `<C-arrow>` resizes splits
- `<F1>` toggles a floating terminal (`nvchad.term`)
- `<Esc>` in terminal mode exits to normal

## Common operations

- `:Lazy sync` — install/update plugins (required after first clone before themes load).
- `:Mason` — install LSP servers/formatters listed above (servers in `lspconfig.lua`, formatters in `conform.lua` must be on `$PATH`).
- `:TSUpdate` — refresh treesitter parsers (ensure-installed list in `lua/plugins/init.lua`). `:TSInstall <lang>` to add one-off.
- `stylua .` — manual lua format using repo's `.stylua.toml`.

`lazy-lock.json` is committed; treat it like a lockfile (commit changes from `:Lazy sync` deliberately).

## nvim-treesitter is pinned to `branch = "master"`

Upstream switched the repo's default branch to `main`, which is a full rewrite with a different API: no `nvim-treesitter.configs.setup`, no `ensure_installed` auto-install, and `:TSInstall`/`:TSUpdate` behave differently. NvChad v2.5 targets the legacy (master) API, so `lua/plugins/init.lua` pins `branch = "master"`. Symptoms if the pin is lost:

- `:TSInstall <lang>` and `:TSUpdate` produce no output.
- `:checkhealth nvim-treesitter` shows only the 7 bundled parsers (`c, lua, markdown, markdown_inline, query, vim, vimdoc`); custom parsers like `angular` never appear.
- Angular templates fall back to html highlighting (no `@if`, `@for`, `ng-content` colors).

Recovery: ensure `branch = "master"` is on the spec, run `:Lazy sync`, **restart Neovim** (Lua module cache holds the old main-branch modules), then `:TSInstall ...`.
