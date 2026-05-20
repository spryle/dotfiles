#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC_MARKER='# personal additions (dotfiles)'
BASHRC_BLOCK='# personal additions (dotfiles)
[ -f ~/.local/bin/bashmarks.sh ] && . ~/.local/bin/bashmarks.sh
# Let bashmarks `g` (go) and `d` (delete) win over Omarchy'"'"'s git/docker aliases
unalias g d 2>/dev/null
[ -f ~/.config/bash/aliases.sh ] && . ~/.config/bash/aliases.sh'

if ! command -v stow >/dev/null 2>&1; then
    echo "[install] stow not found, installing via pacman"
    sudo pacman -S --needed --noconfirm stow
fi

cd "$DOTFILES_DIR"
echo "[install] stowing packages into $HOME"

# SSH needs strict perms before stow links to it, and a sockets dir for ControlMaster.
chmod 700 "$DOTFILES_DIR/ssh/.ssh"
chmod 600 "$DOTFILES_DIR/ssh/.ssh/config"
mkdir -p "$HOME/.ssh/sockets"
chmod 700 "$HOME/.ssh" "$HOME/.ssh/sockets"

# chromium-flags.conf is gitignored (it holds OAuth secrets). Seed it from the
# tracked template on first install; never overwrite a user-edited copy.
CHROMIUM_FLAGS="$DOTFILES_DIR/chromium/.config/chromium-flags.conf"
if [[ ! -f "$CHROMIUM_FLAGS" ]]; then
    cp "$CHROMIUM_FLAGS.example" "$CHROMIUM_FLAGS"
fi

stow --target="$HOME" --restow git bashmarks bash chromium elephant hypr omarchy starship ssh

if ! grep -qF "$BASHRC_MARKER" "$HOME/.bashrc"; then
    echo "[install] adding personal-additions block to ~/.bashrc"
    printf '\n%s\n' "$BASHRC_BLOCK" >> "$HOME/.bashrc"
fi

# Symlink vendored wallpapers into each Omarchy theme's user-backgrounds folder
# (display name matches `omarchy theme list` — dir name title-cased with spaces).
WALLPAPER_SRC="$DOTFILES_DIR/wallpapers/legacy-mountains.png"
if [[ -f "$WALLPAPER_SRC" ]]; then
    echo "[install] installing wallpapers into Omarchy theme background folders"
    shopt -s nullglob
    for theme_dir in "$HOME/.local/share/omarchy/themes"/*/ "$HOME/.config/omarchy/themes"/*/; do
        dir_name="$(basename "$theme_dir")"
        display_name="$(echo "$dir_name" | sed -E 's/(^|-)([a-z])/\1\u\2/g; s/-/ /g')"
        target_dir="$HOME/.config/omarchy/backgrounds/$display_name"
        mkdir -p "$target_dir"
        ln -nsf "$WALLPAPER_SRC" "$target_dir/$(basename "$WALLPAPER_SRC")"
    done
    shopt -u nullglob
fi

echo "[install] done. open a new shell or 'source ~/.bashrc' to use bashmarks (s, g, p, d, l)."
