#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHMARKS_MARKER='# bashmarks (dotfiles)'
BASHMARKS_BLOCK='# bashmarks (dotfiles)
[ -f ~/.local/bin/bashmarks.sh ] && . ~/.local/bin/bashmarks.sh
# Let bashmarks `g` (go) and `d` (delete) win over Omarchy'"'"'s git/docker aliases
unalias g d 2>/dev/null'

if ! command -v stow >/dev/null 2>&1; then
    echo "[install] stow not found, installing via pacman"
    sudo pacman -S --needed --noconfirm stow
fi

cd "$DOTFILES_DIR"
echo "[install] stowing packages into $HOME"
stow --target="$HOME" --restow git bashmarks

if ! grep -qF "$BASHMARKS_MARKER" "$HOME/.bashrc"; then
    echo "[install] adding bashmarks block to ~/.bashrc"
    printf '\n%s\n' "$BASHMARKS_BLOCK" >> "$HOME/.bashrc"
fi

echo "[install] done. open a new shell or 'source ~/.bashrc' to use bashmarks (s, g, p, d, l)."
