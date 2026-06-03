#!/usr/bin/env bash
#
# Install every dotfiles package.
#
# Each package owns an install.sh that installs its dependencies and stows
# its config. This script simply discovers and runs those scripts.
#
# Optional/situational packages (see SKIP below) are not installed by default.
# Run their install.sh directly, e.g.: ./work/install.sh

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# Packages installed first, in this order. The rest follow in any order.
PRIORITY=(zsh tmux mise neovim)

# Packages excluded from the default install.
SKIP=(work audio)

_contains() {
  local needle="$1"; shift
  local item
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

_install_pkg() {
  local install_script="$DOTFILES_DIR/$1/install.sh"
  [ -f "$install_script" ] || { echo "!! no install.sh for $1, skipping"; return; }
  echo "==> Installing $1"
  if ! bash "$install_script"; then
    echo "!! $1 install failed, continuing"
  fi
}

# Priority packages first.
for pkg in "${PRIORITY[@]}"; do
  _install_pkg "$pkg"
done

# Everything else.
for install_script in "$DOTFILES_DIR"/*/install.sh; do
  [ -f "$install_script" ] || continue
  pkg="$(basename "$(dirname "$install_script")")"

  if _contains "$pkg" "${PRIORITY[@]}"; then
    continue
  fi
  if _contains "$pkg" "${SKIP[@]}"; then
    echo "==> Skipping optional package: $pkg"
    continue
  fi

  _install_pkg "$pkg"
done
