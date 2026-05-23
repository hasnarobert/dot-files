# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal macOS dotfiles repo, not a software project. There is no build, no test suite, no lint. The repo's job is to hold configs for sketchybar, AeroSpace, Ghostty, Neovim (LazyVim overlay), oh-my-zsh, and superfile, plus two scripts that place them on a machine.

See `README.md` for the file→destination table and per-app dependency list — don't duplicate it here.

## Working with the install scripts

- **`./install.sh`** copies repo files to their destinations. Hard rule: it **never overwrites**. If a destination exists, the file is skipped. To refresh a single file in place: `rm <destination>` then re-run `./install.sh`. `--dry-run` shows the plan without writing.
- **`./install-dependencies.sh`** installs brew packages, fonts, oh-my-zsh, and OMZ plugins. Idempotent — every step skips if already installed.
- **Do not run either script yourself** unless the user explicitly asks. They mutate the user's `$HOME` and install global packages.

Sketchybar's `helper/` is a C event server. Source is copied by `install.sh`, but the binary is **not** built by it. To build:

```sh
cd ~/.config/sketchybar/helper && make
```

Reload sketchybar after editing any of its files: `brew services restart sketchybar` (or `sketchybar --reload`).

Reload AeroSpace after editing `.aerospace.toml`: `alt-shift-;` then `esc` (the `service` mode `esc` binding triggers `reload-config`).

## Sketchybar architecture (the only non-trivial piece)

Files split across `sketchybar/` form a single runtime:

- `sketchybarrc` is the entry point. Sources `colors.sh` and `icons.sh` (pure variable definitions), then sources every `items/*.sh` it wants on the bar.
- `items/*.sh` declare bar elements and wire them to `plugins/*.sh` via `script=$PLUGIN_DIR/<plugin>.sh`. Items run on events (`update_freq`, `--subscribe <event>`, or `click_script`).
- `plugins/*.sh` are the per-update handlers. They read `$NAME`, `$SENDER`, `$INFO`, `$SELECTED` from the environment that sketchybar passes in, and call back via `sketchybar --set ...`.
- `helper/helper.c` is a single bootstrapped binary registered as a sketchybar event provider. It owns the things too expensive for a shell process per tick: CPU/clock polling (`cpu.h`, `clock.h`) and the `front_app_switched` / space-selection updates. Items subscribe to events it emits.

Cross-file coupling worth knowing before editing:

- `aerospace/.aerospace.toml` fires sketchybar triggers: `exec-on-workspace-change`, `on-focus-changed`, and `on-window-detected` all call `sketchybar --trigger aerospace_workspace_change`. `items/spaces.sh` registers that event and renders the workspace strip. Changing workspace rendering means touching **both** files.
- `items/spaces.sh` shells out to `aerospace list-workspaces` at config-eval time. AeroSpace must be running and on PATH when sketchybar reloads.
- Two fonts are referenced in items and must match what's installed: `SF Pro` (set as `FONT` in `sketchybarrc`), `Hack Nerd Font Mono`, and the special `sketchybar-app-font` (used in `items/spaces.sh` for app icons; not on brew — `install-dependencies.sh` curls the latest release).

## Other gotchas

- **nvim/lua/plugins/colorscheme.lua is an overlay**, not a full nvim config. It assumes LazyVim is already installed at `~/.config/nvim` and only overrides the colorscheme. Do not treat this directory as a complete neovim setup.
- **superfile config lives in `~/Library/Application Support/superfile/`**, not `~/.config/superfile/`. Quote the path with `$HOME` (the space breaks naive `~` expansion in single quotes).
- **`zsh/.zshrc` contains stale `birdsview` user paths** (pnpm `PNPM_HOME`, Docker completions `fpath`). These are intentionally preserved as-is — don't "fix" them without asking.
- **The `the-one` zsh theme goes in `~/.oh-my-zsh/custom/themes/`**, not `~/.oh-my-zsh/themes/`. The custom dir is what survives an OMZ update.
