# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Neovim configuration built on top of **NvChad v2.5** (branch `v2.5`), managed with `lazy.nvim`. Drop the repo at `~/.config/nvim/` and launch `nvim`; lazy.nvim self-bootstraps on first run (see `init.lua`).

## Bootstrap & entrypoint flow

`init.lua` is the single entrypoint and runs in this order:

1. Sets `base46_cache`, `<leader>` = space, clipboard provider = `xclip`.
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

When adding a server, add it to the `servers` table for the simple case. For servers needing a custom `cmd` or `filetypes` (current examples: `angular_cfg`, `compose_cfg` for `docker_compose_language_service`), build the config table and branch on `has("nvim-0.11")` the same way.

Currently enabled in the simple loop: `html`, `cssls`, `ts_ls`, `rust_analyzer`, `tailwindcss`, `dockerls`, `clangd`. Registered separately with custom `cmd`: `angularls` (uses `ngserver` with project-cwd probe paths) and `docker_compose_language_service`.

## Formatting

`conform.nvim` runs on `BufWritePre` with `format_on_save` (lsp_fallback, 500ms timeout). Mapping in `lua/plugins/conform.lua`:

- `stylua` for lua, `prettier` for web (js/ts/json/html/css/scss), `clang-format` for c/cpp, `rustfmt` for rust, `beautysh` for `dosbatch`.

Lua style is locked by `.stylua.toml`: 2-space indent, 120 col width, double quotes preferred, no parens on single-arg calls.

## Filetype quirks

`lua/autocmds.lua` adds:
- `.tsx` → `typescriptreact`, `.jsx` → `javascriptreact`
- `docker-compose.y(a)ml` → `yaml` (so `docker_compose_language_service` attaches via its `filetypes = { "yaml" }`)

## Custom keymaps (in addition to NvChad defaults)

Defined in `lua/mappings.lua`:
- `;` → `:` (normal), `jk` → `<Esc>` (insert)
- `<C-arrow>` resizes splits
- `<F1>` toggles a floating terminal (`nvchad.term`)
- `<Esc>` in terminal mode exits to normal

## Common operations

- `:Lazy sync` — install/update plugins (required after first clone before themes load).
- `:Mason` — install LSP servers/formatters listed above (servers in `lspconfig.lua`, formatters in `conform.lua` must be on `$PATH`).
- `:TSUpdate` — refresh treesitter parsers (ensure-installed list in `lua/plugins/init.lua`).
- `stylua .` — manual lua format using repo's `.stylua.toml`.

`lazy-lock.json` is committed; treat it like a lockfile (commit changes from `:Lazy sync` deliberately).
