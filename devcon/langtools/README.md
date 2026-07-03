# langtools — image-owned editor tooling

This feature installs the editor tooling (LSP servers, formatters, linters, DAP
adapters) for whichever language toolchains are present in the image. It replaces
Neovim's `mason` as the mechanism that provisions that tooling.

## Why this exists

Previously nvim used **mason** to install language servers/formatters at runtime
into `~/.local/share/nvim/mason`. In these devcontainers that directory is the
`devcon-nvim-data` **volume**, which caused two problems:

- **Wrong layer.** Tooling was assembled at first launch into a mounted volume
  instead of being baked into (or provisioned with) the reproducible image. A
  fresh volume = no tooling until mason re-ran.
- **Redundant with the container.** The container already declares its language
  toolchains via devcontainer features (node, python, go, …). Having nvim
  *separately* decide what to install duplicated that knowledge inside the editor.

So we flipped the model:

> **The image owns the tooling; nvim just enables whatever is on `PATH`.**

This is "Approach A" — push tooling into the image, make the editor dumb.

## How it works

```
┌─────────────────────────┐        ┌──────────────────────────────┐
│ devcon/langtools (this)  │        │ nvim config                  │
│ INSTALLS tools -> PATH   │        │ ENABLES tools found on PATH  │
│ (build time, as root)    │        │ (runtime)                    │
│                          │        │                              │
│ gated on command_exists  │        │ gated on vim.fn.executable   │
└─────────────────────────┘        └──────────────────────────────┘
        ▲                                        ▲
        └──── same language map, kept in sync ───┘
             (ubuntu-*.sh) ↔ (core/langs.lua)
```

- **`ubuntu-00.00-50.00.sh`** runs at image build, `installsAfter` the language
  features, and for each detected toolchain (`command_exists node`, `go`, `php`,
  …) installs the matching servers/formatters/adapters to the system `PATH`
  (`/usr/local/bin`, npm `-g` prefix, `GOBIN`). None of these are under the
  `devcon-nvim-data` volume, so they survive a fresh volume.
- **nvim** (`dotfiles/.config/nvim/lua/plugins/lsp__lspconfig.lua`) calls
  `vim.lsp.enable(require("core.langs").servers())`. On Neovim 0.11+, an enabled
  server only launches when its filetype opens *and* its `cmd` is on `PATH`, so
  an absent toolchain is a silent no-op.

### What changed in the nvim config

| File | Change |
|------|--------|
| `lua/plugins/lsp__mason.lua` | **deleted** (mason, mason-lspconfig, mason-tool-installer) |
| `lua/plugins/lsp__lspconfig.lua` | dropped mason deps; keeps `vim.lsp.enable(...)` |
| `lua/plugins/debug__dap.lua` | dropped mason dep; adapters resolve as `js-debug-adapter` / `php-debug-adapter` on `PATH` |
| `lua/core/langs.lua` | removed the `tools` / `mason_tools()` concept; now a pure map of servers / parsers / formatters-by-ft; enables `rust_analyzer` |

Tree-sitter parsers are **not** handled here — they're nvim-specific artifacts
that live under the volume, so they're compiled in `postCreate.sh`
(`TSInstallSync` over `core.langs.parsers()`). Baking `.so`s into the image was
rejected because it fights both the volume and the fact that the dotfiles config
is only symlinked at postCreate time, not at build.

## Adding a language / tool

Two edits, kept in sync by hand:

1. **`ubuntu-00.00-50.00.sh`** — add a `command_exists <bin>` block that installs
   the server/formatter to `PATH`.
2. **`../../dotfiles/.config/nvim/lua/core/langs.lua`** — add the `servers` /
   `parsers` / `ft` entries so nvim enables them.

If the tool comes from a new devcontainer feature, also add that feature's id to
`installsAfter` in `devcontainer-feature.json` so this runs after it.

## Known caveats

- **Two sources of truth.** `langs.lua` (what nvim enables) and this installer
  (what gets installed) list the same tools and must be kept in sync manually.
  This is the inherent cost of Approach A versus mason's single list.
- **User-scoped version managers.** apt/npm-global/`go install`/downloaded
  binaries bake cleanly as root at build time. But **ruby uses rbenv** and
  **rust uses rustup**, which are per-user — whether `gem install ruby-lsp` and
  `rustup component add rust-analyzer` land on the runtime user's `PATH` depends
  on the shim layout. Both are marked with `WARN` logs; if they don't resolve,
  move just those installs into `postCreate.sh` (runs as the `bchk` user).
- **Download URLs pin to latest.** `gh_latest` hits the unauthenticated GitHub
  API and release-asset paths (`--strip-components`, the `.vsix` internal path)
  are assumptions — validate on the first build.
- **jdtls (Java)** is not installed yet; left as a follow-up in the script.

## Validating

```sh
make -C devcon features-publish-langtools   # publish the feature first
make -C devcon build-<persona>              # then build a persona that uses it
```

Inside the container:

```vim
:checkhealth vim.lsp     " server should be attached for the open filetype
:echo exepath('gopls')   " (and pyright, clangd, …) should be non-empty
```

Loose end: `lazy-lock.json` still pins the mason plugins, but nothing references
them, so lazy ignores them. Run `:Lazy clean` to prune when convenient.
