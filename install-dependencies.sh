#!/usr/bin/env bash
# install-dependencies.sh — Install everything the configs in this repo depend
# on: brew taps, formulae, casks, fonts, oh-my-zsh and its custom plugins.
#
# Safe to re-run: every step skips if the thing is already installed.
# Does NOT copy config files — use ./install.sh for that.

set -euo pipefail

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  +\033[0m %s\n' "$*"; }
skip() { printf '\033[1;33m  ~\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m  !\033[0m %s\n' "$*"; }
err()  { printf '\033[1;31m  x\033[0m %s\n' "$*" >&2; }

# -- prerequisites --
log "prerequisites"
if ! command -v brew >/dev/null 2>&1; then
  err "Homebrew is required. Install from https://brew.sh and re-run."
  exit 1
fi
ok "homebrew: $(command -v brew)"

if xcode-select -p >/dev/null 2>&1; then
  ok "Xcode Command Line Tools: $(xcode-select -p)"
else
  warn "Xcode Command Line Tools not detected."
  warn "  Install with: xcode-select --install"
  warn "  (Required to build the sketchybar helper binary.)"
fi

# -- brew helpers --
brew_tap() {
  if brew tap | grep -qx "$1"; then
    skip "tap $1"
  else
    log "tap $1"
    brew tap "$1"
  fi
}

brew_formula() {
  if brew list --formula "$1" >/dev/null 2>&1; then
    skip "formula $1"
  else
    log "install formula $1"
    brew install "$1"
  fi
}

brew_cask() {
  # Tap-prefixed cask names (e.g. nikitabobko/tap/aerospace) install fine,
  # but `brew list --cask` checks by the short name.
  local short="${1##*/}"
  if brew list --cask "$short" >/dev/null 2>&1; then
    skip "cask $short"
  else
    log "install cask $1"
    brew install --cask "$1"
  fi
}

# -- taps --
log "homebrew taps"
brew_tap felixkratz/formulae
brew_tap nikitabobko/tap

# -- formulae --
log "homebrew formulae"
brew_formula sketchybar      # status bar
brew_formula borders         # JankyBorders, window borders
brew_formula neovim          # nvim
brew_formula eza             # ls replacement (aliased in .zshrc)
brew_formula gh              # used by sketchybar/plugins/github.sh
brew_formula jq              # JSON parser
brew_formula superfile       # TUI file manager

# -- casks --
log "homebrew casks (apps & fonts)"
brew_cask nikitabobko/tap/aerospace   # tiling WM
brew_cask ghostty                     # terminal
brew_cask font-sf-pro                 # main sketchybar font
brew_cask font-hack-nerd-font         # mono font (separators, system stats)

# -- sketchybar-app-font (not on brew) --
log "sketchybar-app-font"
APP_FONT="$HOME/Library/Fonts/sketchybar-app-font.ttf"
APP_FONT_URL="https://github.com/kvndrsslr/sketchybar-app-font/releases/latest/download/sketchybar-app-font.ttf"
if [[ -f "$APP_FONT" ]]; then
  skip "sketchybar-app-font already at $APP_FONT"
else
  log "downloading sketchybar-app-font (latest release)"
  mkdir -p "$(dirname "$APP_FONT")"
  curl -fL "$APP_FONT_URL" -o "$APP_FONT"
  ok "$APP_FONT"
fi

# -- oh-my-zsh --
log "oh-my-zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  skip "oh-my-zsh already installed"
else
  log "installing oh-my-zsh (unattended)"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# -- oh-my-zsh custom plugins --
log "oh-my-zsh custom plugins"
OMZ_PLUGINS="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

clone_plugin() {
  local url="$1" dst="$2" name
  name="$(basename "$dst")"
  if [[ -d "$dst" ]]; then
    skip "$name"
  else
    log "cloning $name"
    git clone --depth=1 "$url" "$dst"
  fi
}
clone_plugin https://github.com/zsh-users/zsh-autosuggestions \
             "$OMZ_PLUGINS/zsh-autosuggestions"
clone_plugin https://github.com/zdharma-continuum/fast-syntax-highlighting \
             "$OMZ_PLUGINS/fast-syntax-highlighting"

log "done"
echo
echo "Next steps:"
echo "  1. Run ./install.sh to place the config files."
echo "  2. Build the sketchybar helper binary:"
echo "       cd ~/.config/sketchybar/helper && make"
echo "  3. Start services:"
echo "       brew services start sketchybar"
echo "       brew services start borders"
echo "  4. Open AeroSpace.app once to grant Accessibility permissions."
