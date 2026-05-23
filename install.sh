#!/usr/bin/env bash
# install.sh — Copy config files from this repo to their system locations.
#
# Will NEVER overwrite an existing destination file: if it exists, it's
# skipped and a notice is printed. Delete the destination by hand if you
# want to update it from this repo.
#
# Usage:
#   ./install.sh            # do the install
#   ./install.sh --dry-run  # print what would happen, change nothing

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  +\033[0m %s\n' "$*"; }
skip() { printf '\033[1;33m  ~\033[0m skip (exists): %s\n' "$*"; }

# Copy SRC to DST. Skip if DST already exists. Create parent dir as needed.
copy_file() {
  local src="$1" dst="$2"
  if [[ -e "$dst" ]]; then
    skip "$dst"
    return 0
  fi
  if [[ "$DRY_RUN" -eq 1 ]]; then
    ok "DRY-RUN would copy $src -> $dst"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp -p "$src" "$dst"
  ok "$dst"
}

# Recursively copy every file under SRC_DIR into DST_DIR, preserving relative
# paths. Per-file skip-if-exists still applies.
copy_tree() {
  local src_dir="$1" dst_dir="$2" rel f
  while IFS= read -r -d '' f; do
    rel="${f#"$src_dir"/}"
    copy_file "$f" "$dst_dir/$rel"
  done < <(find "$src_dir" -type f -print0)
}

log "installing from $REPO_DIR"
[[ "$DRY_RUN" -eq 1 ]] && log "(dry run — no files will be written)"

log "aerospace"
copy_file "$REPO_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"

log "ghostty"
copy_file "$REPO_DIR/ghostty/config" "$HOME/.config/ghostty/config"

log "zsh"
copy_file "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"

log "oh-my-zsh theme"
copy_file "$REPO_DIR/oh-my-zsh-theme/the-one.zsh-theme" \
          "$HOME/.oh-my-zsh/custom/themes/the-one.zsh-theme"

log "superfile theme"
copy_file "$REPO_DIR/superfile/theme/onedark-custom.toml" \
          "$HOME/Library/Application Support/superfile/theme/onedark-custom.toml"

log "nvim colorscheme overlay"
copy_file "$REPO_DIR/nvim/lua/plugins/colorscheme.lua" \
          "$HOME/.config/nvim/lua/plugins/colorscheme.lua"

log "sketchybar (full tree)"
copy_tree "$REPO_DIR/sketchybar" "$HOME/.config/sketchybar"

log "done"
echo
echo "Next step (one-time, after the helper sources have been copied):"
echo "  cd ~/.config/sketchybar/helper && make"
echo
echo "Then reload sketchybar:"
echo "  brew services restart sketchybar"
