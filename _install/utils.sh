#!/usr/bin/env bash
set -e
set -u
set -o pipefail

# Root of the dotfiles repo. Overridable, defaults to ~/dotfiles.
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

# Run the system package manager (brew on macOS).
# Usage: _use_package_manager {add|remove|search} <package>
function _use_package_manager() {
  local pack_man cmd
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Brew not installed"
      return 1
    fi
    pack_man="HOMEBREW_NO_ENV_HINTS=1 brew"
    case "$1" in
      add) cmd="install" ;;
      remove) cmd="uninstall" ;;
      *) cmd="search" ;;
    esac
  else
    echo "We are on Linux I guess..."
    return 0
  fi
  eval "$pack_man" "$cmd" "$2"
}

# Install one or more packages via the system package manager (no stow).
# Usage: brew_install <package> [package...]
function brew_install() {
  local pkg
  for pkg in "$@"; do
    _use_package_manager add "$pkg"
  done
}

# Symlink (or unlink) a stow package's config into $HOME.
# install.sh is ignored so it never gets symlinked.
# Usage: _safely_stow {add|remove} <package>
function _safely_stow() {
  if [ -d "$DOTFILES_DIR/$2" ]; then
    if ! command -v stow >/dev/null 2>&1; then
      echo "stow not installed, installing..."
      _use_package_manager add stow
    fi
    if [ "$1" = "add" ]; then
      stow --ignore='install\.sh' -d "$DOTFILES_DIR" -v "$2"
    elif [ "$1" = "remove" ]; then
      stow -d "$DOTFILES_DIR" -vD "$2"
    fi
  else
    echo "stow package not found: $DOTFILES_DIR/$2"
  fi
}

# Stow a package's config without installing anything.
# Usage: stow_pkg <package>
function stow_pkg() {
  _safely_stow add "$1"
}

# Install a package and stow its config.
# Usage: do_install <package>
function do_install() {
  _use_package_manager add "$1"
  _safely_stow add "$1"
}
