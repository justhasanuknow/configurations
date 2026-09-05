# CLAUDE.md — working rules for this repository

This is my personal dotfiles repository. It is public, it is checked out on several machines (WSL/Ubuntu, EndeavourOS laptops, a VM, later a workstation and a server), and every machine is set up with `./install.sh` (`--desktop` on machines with a screen). Read `README.md` first; it describes what exists. This file describes how to change it.

## What this repo is

* GNU stow layout. One directory per tool (`nvim/`, `tmux/`, `zsh/`, `hypr/`, …). Each package mirrors `$HOME` internally, e.g. `hypr/.config/hypr/hyprland.lua` is stowed to `~/.config/hypr/hyprland.lua`. New tools get their own package unless they are part of a family that already has one (Hyprland companions live in `hypr/`; small executables live in `scripts/.local/bin/`).
* Terminal and desktop are separate. `PACKAGES` in `install.sh` is linked everywhere; `DESKTOP_PACKAGES` only with `--desktop`, and only on Arch-based systems. Never make a terminal package depend on a desktop one.
* Guiding principle: don't install a plugin, package or tool for a pain that hasn't been felt. Prefer configuration over new dependencies. If a task needs a new dependency, say so in the summary and explain why.

## Hard rules

1. Machine-specific settings are never committed. Monitors, scale, VM workarounds, git identity, credential helpers, per-host overrides. The existing mechanisms: `~/.gitconfig.local` (written by `install.sh`), `hypr/.config/hypr/machine.lua` (gitignored, seeded from `machine.lua.example`), `kitty/.config/kitty/local.conf` (gitignored). Follow the same pattern for anything new: a committed `*.example` plus a gitignored real file, and a line in `install.sh` that seeds it.
2. No secrets, ever. No tokens, keys, passwords, SSH config, hostnames of private machines, or email addresses in committed files.
3. LF line endings only. `.gitattributes` enforces `eol=lf`; `.editorconfig` states it. Never introduce CRLF. If a file arrives with CRLF, normalise it (`perl -pi -e 's/\r//g'`) and mention it. A CR in a shebang line breaks every script.
4. Code and comments in English. Every new config file starts with a one-line comment saying what it is for. Prose in `README.md` and `KEYBINDS.md` is English.
5. Do not commit. Leave the working tree for me to review with `git status` and `git diff`. Never run `git push`.
6. Do not reformat files you were not asked to change. Formatting-only diffs hide real changes. Lua is formatted with stylua (`.stylua.toml` is in the repo); run it only on files you touched.
7. `install.sh` stays idempotent and cross-distro. Running it twice must be a no-op. Package installs go through the existing `install_packages_debian` / `install_packages_arch` / `install_desktop` functions. Anything upstream-only follows the `ensure_*` pattern (version check, then download). Run `bash -n install.sh` after editing it.

## Tool-specific conventions

### Neovim (`nvim/`)

* lazy.nvim, one file per plugin under `lua/hasan/plugins/`, each returning a spec.
* Plugin-specific keymaps live in the plugin's file; global ones in `lua/hasan/keymaps.lua`.
* Leader is Space. Prefix groups are named in `which-key.lua` (`f` find, `g` git, `c` code, `l` lsp, `s` swap, `e` explorer). Put new mappings under the right prefix and add a `desc`. `timeoutlen` is 300 ms, so prefer two-key chords over three.
* LSP: mason installs servers, nvim-lspconfig supplies configs, Neovim activates them with `vim.lsp.enable`. Never use the old `require("lspconfig").x.setup{}` API.
* Treesitter: the community fork `neovim-treesitter/nvim-treesitter` (the original is archived). Do not switch it back, and do not copy the fork's README install snippet — it shows the old repository path.
* Telescope tracks `master` on purpose (`0.1.x` breaks on Neovim 0.12).
* `lazy-lock.json` is committed and authoritative. Do not run `:Lazy update`; if a task requires a newer plugin, say so and let me update.
* Formatting is manual (`<leader>cf`). Do not add format-on-save.

### Hyprland (`hypr/`)

* Config is Lua (Hyprland 0.55+). `hyprland.lua` only `require()`s modules: `look.lua`, `binds.lua`, `rules.lua`, `autostart.lua`, plus the untracked `machine.lua`.
* Do not rely on memory for the `hl.*` API — it is newer than most training data. Check the installed reference (`/usr/share/hypr/hyprland.lua`) and the stubs that `.luarc.json` points at (find them with `pacman -Ql hyprland | grep -i '\.lua'`).
* After every change run `hyprctl configerrors`. `hyprctl reload` prints `ok` even when the config is broken.
* Companion programs (hyprpaper, hyprlock, hypridle, mako, waybar, wofi) each have their own config format; consult the installed example or man page before writing one.
* Anything the Hyprland session launches must use absolute paths (`$HOME/.local/bin/...`); the session shell does not read `.zshrc`, so `~/.local/bin` is not on its PATH.
* Colours: rose-pine palette. Base `#191724`, surface `#1f1d2e`, overlay `#26233a`, muted `#6e6a86`, subtle `#908caa`, text `#e0def4`, love `#eb6f92`, gold `#f6c177`, rose `#ebbcba`, pine `#31748f`, foam `#9ccfd8`, iris `#c4a7e7`. Font: `JetBrainsMono Nerd Font`.

### tmux (`tmux/`)

* Prefix `Ctrl-a`. Plugins via TPM (declared in `.tmux.conf`, installed by `install.sh`).
* `Ctrl-h/j/k/l` are shared with Neovim through vim-tmux-navigator; do not rebind them.
* Binds that run a script use absolute paths (see `bind f`).

### zsh (`zsh/`)

* No framework. Plugins go through the `zsh_plugin` loader in `.zshrc`, nothing else.
* Keep startup fast: nothing that forks on every prompt, nothing that scans the disk at startup.

### Scripts (`scripts/`)

* Bash, `#!/usr/bin/env bash`, `set -euo pipefail`, a usage comment at the top, executable bit set. Run `bash -n` on anything you touch.

## When a task changes behaviour

* Update `README.md` (the relevant section and, if applicable, Requirements and Roadmap).
* Update `KEYBINDS.md` for any new or changed key binding, in any program.
* Add new packages to `install.sh` in the same style as the existing entries.

## Verification

Run what applies on this machine and report what you could not run:

```bash
bash -n install.sh; for f in scripts/.local/bin/*; do bash -n "$f"; done
grep -rlP '\x0d' . --exclude-dir=.git          # must print nothing
nvim --headless "+Lazy! restore" +qa           # Neovim config still loads
hyprctl configerrors                            # inside a Hyprland session; must print nothing
```

## How to finish

End with a short summary: files added/changed, packages added, new key bindings, anything you were unsure about (with the exact command I should run to verify), and anything you deliberately left out and why.
