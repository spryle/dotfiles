# dotfiles

Personal dotfiles for [Omarchy](https://omarchy.org/) (Arch Linux + Hyprland), managed with [GNU Stow](https://www.gnu.org/software/stow/) and a small idempotent `install.sh`.

## Quick start

```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
# First-time on a new machine? Walk through hosts/<your-machine>.md first.
./install.sh
```

`install.sh` is idempotent — re-run any time, after pulling new commits, or after `omarchy update`.

## What's in it

| Package | Lands at | Purpose |
|---|---|---|
| `git/` | `~/.config/git/{config,ignore}` | Identity + aliases, merged with Omarchy's defaults (XDG path, no `~/.gitconfig`) |
| `bashmarks/` | `~/.local/bin/bashmarks.sh` | Directory bookmarks — `s name`, `g name`, `p name`, `d name`, `l` |
| `bash/` | `~/.config/bash/aliases.sh` | Personal shell aliases (`p='pnpm'`, …) |
| `chromium/` | `~/.config/chromium-flags.conf` | Omarchy's Wayland defaults + `--disable-pinch` (seeded from `.example`, gitignored — holds local OAuth secrets) |
| `elephant/` | `~/.config/elephant/desktopapplications.toml` | Walker app launcher: rank by recent-use (`history`/`history_when_empty`) instead of alphabetical |
| `hypr/` | `~/.config/hypr/{input,monitors,envs,bindings}.conf` | Touchpad + GB keyboard, HiDPI scale, NVIDIA env vars |
| `omarchy/` | `~/.config/omarchy/branding/screensaver.txt` | Custom ASCII-art screensaver banner |
| `starship/` | `~/.config/starship.toml` | Catppuccin Powerline preset |
| `ssh/` | `~/.ssh/config` | 1Password SSH agent + ControlMaster multiplexing + named hosts |
| `waybar/` | `~/.config/waybar/config.jsonc` | Top bar: show only occupied workspaces (no persistent 1-5 placeholders) |
| `wallpapers/` | symlinked into every Omarchy theme | Personal wallpaper, joins the cycle for whichever theme is active |

## How it works

Each top-level folder (except `wallpapers/`, `hosts/`, `system/`, and `notes/`) is a stow package whose internal layout mirrors `$HOME`. So `git/.config/git/config` lands at `~/.config/git/config` as a symlink back into the repo — edit either place, you're editing the same file.

`install.sh` handles the bits stow alone can't:

- installs stow via pacman if missing
- sets perms on SSH files (`600` on `config`, `700` on `~/.ssh` and `~/.ssh/sockets/`) — git doesn't track those mode bits
- appends a personal-additions block to Omarchy's `~/.bashrc` (sourcing bashmarks + aliases, plus `unalias g d` so bashmarks wins over Omarchy's `git`/`docker` aliases)
- fans the wallpaper out into every Omarchy theme's user-backgrounds folder

## Adding a new config

1. Create `pkg-name/` in the repo, mirroring the target path: e.g. `pkg-name/.config/<app>/<file>`.
2. Add `pkg-name` to the `stow --restow` line in `install.sh`.
3. If the target already exists on disk (Omarchy ships defaults for most things), delete it before stowing — stow refuses to clobber real files.
4. Re-run `./install.sh` and commit.

When forking an Omarchy default, copy the current template (from `~/.local/share/omarchy/config/<app>/`) into your stow package first, then layer your changes on top.

## System config (needs root)

`system/` mirrors `/etc` and holds non-host-specific config that must live outside `$HOME`. The top-level `install.sh` doesn't touch `/etc` — apply these with the dedicated installer, which copies each tracked file to its mirrored `/etc` path and restarts any affected services:

```bash
./system/install.sh   # asks for sudo password once
```

Idempotent — re-run after pulling new commits. Currently installs:

- `etc/systemd/resolved.conf.d/dns.conf` — route DNS through Cloudflare + Quad9 (via `Domains=~.` so it overrides DHCP-pushed resolvers on every link), bypassing ISP-level DNS filtering. See the file header for the rationale.

## Per-host notes

Anything host-specific that can't live in `$HOME` (kernel command line, BIOS, hardware quirks, third-party GUI toggles) goes in `hosts/<machine>.md` as a checklist, with any tracked system files under `hosts/<machine>/etc/...`. Walk through the relevant file before running `install.sh` on a fresh box.

## App setup notes

`notes/` collects per-application setup gotchas that apply across hosts and aren't config files — first-run procedures, why certain choices were made, workarounds for known bugs. Skim the relevant file when installing the app on a fresh machine.

- [`notes/expressvpn.md`](notes/expressvpn.md) — CLI-only setup (Qt GUI unusable on HiDPI), activation via temp file, background-mode flag.
