# ExpressVPN

CLI-only on Omarchy. The bundled Qt GUI hardcodes its dimensions and is
unusable on HiDPI displays (see *Why CLI* below).

## Install

```bash
yay -S expressvpn
sudo systemctl enable --now expressvpn-service.service
```

The AUR `expressvpn` package is the official ExpressVPN binary repackaged
for Arch. It ships both the GUI (`/usr/bin/expressvpn-client`) and the CLI
(`/usr/bin/expressvpnctl`). The service unit is `expressvpn-service.service`
(not `expressvpn.service`).

If `yay -S expressvpn` fails with `curl: (35) TLS connect error` while
downloading from `expressvpn.works`, the host's DNS is being hijacked by
ISP-level filtering. The `system/etc/systemd/resolved.conf.d/dns.conf`
drop-in fixes this — apply via `./system/install.sh` and retry.

## First-time activation

The CLI reads the activation code from a file (there's no `--code` flag).
Use a temp file so the code doesn't land on disk or in shell history:

```bash
codefile=$(mktemp) && chmod 600 "$codefile"
read -srp "Activation code: " code && printf '%s\n' "$code" > "$codefile" && unset code; echo
expressvpnctl login "$codefile"
shred -u "$codefile"
```

Then enable background mode so `expressvpnctl connect` works without the
GUI running:

```bash
expressvpnctl background enable
```

Background mode also enables autoconnect on system startup.

## Daily use

The `vpn` alias (defined in `bash/.config/bash/aliases.sh`) is the only
shortcut tracked:

```bash
vpn connect              # smart location (auto-picks fastest)
vpn connect uk-london
vpn status
vpn disconnect
vpn get locations | less
vpn logout               # sign out on this machine
```

`vpn` is just `alias vpn='expressvpnctl'` — every subcommand works the same
as the underlying tool.

## Why CLI

The Qt6 GUI hardcodes its root window at 366×220 logical pixels in QML and
honors no external scaling input — `QT_SCALE_FACTOR`, Wayland mode, and
Hyprland windowrules all fail to enlarge the actual UI (a windowrule grows
the *frame* but leaves the UI pinned in the top-left, with black filling
the rest). On a 4K 13" display at scale 3, the result is a ~3cm × 2cm
unreadable widget.

Workarounds rejected:
- **`xwayland:force_zero_scaling = false`** — Xwayland upscales the surface,
  but it's a global Hyprland setting that softens every X11 app's rendering.
  Not worth it for one program.
- **`gamescope` wrapper** — nested compositor, works but heavy for a VPN client.
- **Native Wayland** (`QT_QPA_PLATFORM=wayland`) — bundled Wayland plugin
  exists in `/opt/expressvpn/plugins/platforms/`, but the binary still
  presents as Xwayland and the fixed-size QML wins anyway.

`expressvpnctl` covers the full feature set (connect, locations, kill switch,
split tunnel, status) and is genuinely the better tool on HiDPI. Revisit the
GUI if ExpressVPN ships a HiDPI-aware build.
