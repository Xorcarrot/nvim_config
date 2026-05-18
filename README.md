# nvim_config

Personal Neovim configuration on top of **NvChad v2.5**, managed by `lazy.nvim`.

## Prerequisites

Install on your system before cloning:

| Tool | Why |
| ---- | --- |
| `nvim` ≥ **0.11** | `lspconfig.lua` uses the `vim.lsp.config` / `vim.lsp.enable` API |
| `git` | Plugin installation |
| `cc` / `gcc` (e.g. `build-essential`) | Compiles tree-sitter parsers |
| `node` ≥ 18 | Required by `angularls`, `ts_ls`, `tailwindcss`, `prettier` |
| `xclip` (Linux/X11) or `wl-clipboard` (Wayland) | System clipboard (`clipboard = unnamedplus`) |
| `ripgrep`, `fd` | Telescope live-grep and file find |

Formatters (install via Mason **or** system package manager — they must be on `$PATH`):

- `stylua` — lua
- `prettier` — js/ts/json/html/css/scss
- `clang-format` — c/cpp
- `rustfmt` — rust (ships with rustup)
- `beautysh` — Windows batch files

## Install

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

`init.lua` bootstraps `lazy.nvim` automatically on first launch. **Expect errors on the first run** — base46 highlight caches don't exist until plugins finish syncing. Don't panic; do the next two steps.

## First-run setup (in order)

1. **`:Lazy sync`** — installs all plugins. Wait for the loader to finish.
2. **Quit and restart Neovim.** This is required: base46 cache files are written during sync, and `init.lua` `dofile`s them at startup; if you skip the restart, theme highlights are missing.
3. **`:Mason`** — install LSP servers and any formatters not provided by your system. Required servers (mapped in `lua/configs/lspconfig.lua`):
   - `html`, `cssls`, `ts_ls`, `rust_analyzer`, `tailwindcss`, `dockerls`, `clangd`
   - `angularls`, `docker-compose-language-service`
4. **`:TSInstall angular html css scss javascript typescript tsx json yaml dockerfile rust`** — compile tree-sitter parsers. The `ensure_installed` list in `lua/plugins/init.lua` is *supposed* to auto-install on first load, but in practice it can miss the trigger after lazy-loading; running `:TSInstall` explicitly is the reliable path. Verify with `:checkhealth nvim-treesitter` — every parser should show `H ✓` (highlight available).
5. **`:checkhealth`** — sanity-check everything. Address any red/yellow items before reporting bugs.

## Angular setup (per-project)

`angularls` resolves the Angular language service from the project's `node_modules/@angular/language-service`. **In each Angular project**, run:

```bash
npm install
```

before opening Neovim, otherwise `ngserver` crashes with `Failed to resolve '@angular/language-service'`.

Angular template highlighting requires the `angular` tree-sitter parser (installed in step 4) **and** the file's filetype to be `htmlangular`. The autocmd in `lua/autocmds.lua` handles this automatically: any `*.html` inside a directory tree that contains an `angular.json` (searching upward, stopping at `$HOME`) is set to `htmlangular`. Verify on a template: `:set filetype?` should print `htmlangular`.

## Pinned versions to be aware of

- **`NvChad/NvChad`** — branch `v2.5` (in `init.lua`).
- **`NvChad/ui`** — branch `v3.0` (transitive; chadrc schema must match `v3.0/lua/nvconfig.lua`).
- **`nvim-treesitter`** — branch **`master`** (pinned in `lua/plugins/init.lua`). Upstream's default branch is now `main`, a rewrite with an incompatible API that breaks NvChad. **Do not remove the pin.** See `CLAUDE.md` § "nvim-treesitter is pinned to `branch = master`" for symptoms and recovery.
- **`lazy-lock.json`** is committed. Commit changes from `:Lazy sync` deliberately.

## Troubleshooting

| Symptom | Cause | Fix |
| ------- | ----- | --- |
| Colors look wrong / errors mentioning `base46` on startup | First-run base46 cache not built yet | `:Lazy sync`, restart nvim |
| `:TSInstall` prints nothing or says `Argument required` after a branch switch | Lua module cache holds old `nvim-treesitter` modules | Restart Neovim, then `:TSInstall <lang>` |
| `:checkhealth nvim-treesitter` only lists `c, lua, markdown, markdown_inline, query, vim, vimdoc` | Treesitter pinned to `main` instead of `master`, or parsers never installed | Confirm `branch = "master"` in `lua/plugins/init.lua`, `:Lazy sync`, restart, `:TSInstall ...` |
| Angular template has no `@if`/`@for`/`ng-content` highlighting | Filetype is `html`, not `htmlangular`, or `angular` parser missing | `:set filetype?` to confirm; if `html`, check that `angular.json` exists in the project root. If `htmlangular` but still no colors, `:TSInstall angular` |
| `angularls` fails with `Failed to resolve '@angular/language-service'` | Project's `node_modules` missing | `npm install` in the project, restart nvim |
| Formatter doesn't run on save | Binary not on `$PATH` | Install via Mason or system package manager |

## Layout

See `CLAUDE.md` for the architectural overview (bootstrap flow, where to put what, LSP/formatter conventions, custom keymaps).
