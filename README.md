# dot-files

Personal macOS configuration for sketchybar, AeroSpace, Ghostty, Neovim, oh-my-zsh, and superfile.

## What's in this repo

| Path | What it is | Installed to |
|------|-----------|--------------|
| `aerospace/.aerospace.toml` | AeroSpace tiling WM config | `~/.aerospace.toml` |
| `ghostty/config` | Ghostty terminal config | `~/.config/ghostty/config` |
| `nvim/lua/plugins/colorscheme.lua` | LazyVim colorscheme override (onedark, custom bg) | `~/.config/nvim/lua/plugins/colorscheme.lua` |
| `oh-my-zsh-theme/the-one.zsh-theme` | Custom oh-my-zsh prompt theme | `~/.oh-my-zsh/custom/themes/the-one.zsh-theme` |
| `sketchybar/` | Full sketchybar config (bar, items, plugins, C helper) | `~/.config/sketchybar/` |
| `superfile/theme/onedark-custom.toml` | superfile color theme | `~/Library/Application Support/superfile/theme/onedark-custom.toml` |
| `zsh/.zshrc` | Shell config | `~/.zshrc` |

## Quick start (fresh machine)

```sh
./install-dependencies.sh                    # brew packages, fonts, OMZ + plugins
./install.sh                                 # copy config files into place
cd ~/.config/sketchybar/helper && make       # compile the sketchybar helper
brew services start sketchybar
brew services start borders
```

Open `AeroSpace.app` once to grant Accessibility permissions, then start a new shell session so the new `.zshrc` is loaded.

## Scripts

### `install.sh`

Copies every config file in this repo to its system destination.

- **Never overwrites.** If the destination file already exists, it is skipped and printed as such. Delete the destination by hand if you want to refresh it from the repo.
- **Preserves the executable bit** on shell scripts (uses `cp -p`).
- **Creates parent directories** as needed.
- **`--dry-run`** shows what would be copied without writing anything.

```sh
./install.sh --dry-run
./install.sh
```

### `install-dependencies.sh`

Installs the brew packages, fonts, oh-my-zsh, and OMZ custom plugins that the configs depend on. Idempotent — every step skips when the thing is already present.

Requires [Homebrew](https://brew.sh). Warns (but does not bail) if Xcode Command Line Tools are missing — those are needed to build the sketchybar helper binary.

## Dependencies by app

### sketchybar
- **Binaries**: `sketchybar`, `borders`, `aerospace`, `gh`, `jq`
- **Fonts**:
  - `SF Pro` (cask `font-sf-pro`) — main bar font; uses Regular, Bold, Semibold, Heavy, and Black variants
  - `Hack Nerd Font Mono` (cask `font-hack-nerd-font`) — separators and system-stats labels
  - `sketchybar-app-font` — app-icon glyphs, from [kvndrsslr/sketchybar-app-font](https://github.com/kvndrsslr/sketchybar-app-font/releases); placed at `~/Library/Fonts/sketchybar-app-font.ttf`
- **Build toolchain**: `clang` and `make` (Xcode Command Line Tools) to compile `sketchybar/helper/helper.c`

### aerospace
- `aerospace` (cask, from `nikitabobko/tap`)
- Refers at runtime to `sketchybar` (workspace-change trigger), `borders` (startup hook), and `Ghostty.app` (`alt-t` shortcut).

### ghostty
- `Ghostty.app` (cask `ghostty`). Theme "Atom One Dark" ships with the app.

### nvim
- `neovim`
- Assumes [LazyVim](https://www.lazyvim.org/) is already set up at `~/.config/nvim`. The `colorscheme.lua` overlay declares `navarasu/onedark.nvim`; lazy.nvim installs it on first launch.

### oh-my-zsh + theme
- [Oh My Zsh](https://ohmyz.sh/) at `~/.oh-my-zsh`
- Custom plugins (cloned by `install-dependencies.sh`):
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  - [fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- The `the-one` theme is activated by `ZSH_THEME="the-one"` in `.zshrc`.

### zsh (.zshrc)
- Oh My Zsh (above)
- `eza` — `ls` replacement (aliased)
- `nvim` — aliased as `vim`
- `nvm` at `~/.nvm` — Node Version Manager (install separately if needed)
- `pnpm` — note: the checked-in `.zshrc` references a stale `birdsview` user path; review before reusing on another account.

### superfile
- `superfile` binary (formula `superfile`)

## Updating a single file after the first install

`install.sh` won't overwrite, by design. To refresh one file:

```sh
rm ~/.config/sketchybar/items/spaces.sh    # delete the destination
./install.sh                               # re-run; new copy is placed
```

Or just copy the single file by hand.

## Notes

- macOS only.
- The repo intentionally ships only a LazyVim *overlay* (`colorscheme.lua`), not the full nvim config.
- Neither script touches `.git`, system services, or anything outside the paths listed in the table above.
