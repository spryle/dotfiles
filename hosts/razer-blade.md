# Razer Blade — per-host setup

Manual steps for this machine that live outside `$HOME`, need root, or are
hardware-specific. Do these *before* running `./install.sh` on a fresh
Omarchy install.

## Kernel command line (required to boot)

Without these flags Omarchy hangs at boot.

Append to `KERNEL_CMDLINE[default]` in `/etc/default/limine`:

```
intremap=off button.lid_init_state=open
```

Then regenerate the bootloader config:

```bash
sudo limine-update
```

### Why

- `intremap=off` — Razer's IOMMU interrupt-remapping table misroutes IRQs
  on Optimus chassis; without it the kernel hangs at boot. Small DMA
  interrupt-isolation trade-off, accepted.
- `button.lid_init_state=open` — the ACPI `_LID` method reports a bogus
  initial state at boot; without this the kernel can suspend or refuse to
  power displays before the first real lid event arrives.

## Touchpad phantom-finger workaround (libinput quirks)

Install the bundled libinput quirks file for the Synaptics touchpad:

```bash
sudo install -Dm644 hosts/razer-blade/etc/libinput/local-overrides.quirks \
    /etc/libinput/local-overrides.quirks
```

Verify libinput picked it up — should print `ModelTouchpadPhantomClicks=1`:

```bash
libinput quirks list /dev/input/event14  # adjust event number if different
```

Then log out and back into Hyprland (libinput only reads quirks when devices
are added).

### Why

The touchpad is Synaptics `06CB:CDA3` over i2c-HID, enumerated under custom
ACPI ID `CUST0001`. Its firmware briefly reports phantom second-finger
contacts during single-finger use — `evtest /dev/input/event14` shows
~85 phantom `BTN_TOOL_DOUBLETAP` toggles per 30s of normal use, many as
short as 6ms. libinput sees these and trips gesture/scroll detection,
producing phantom pinch-zoom (the `--disable-pinch` Chromium flag
mitigates the worst case but the bug exists at the input layer).

The same bug surfaces on Windows, so it's firmware, not driver. The
touchpad does **not** expose pressure or contact-size axes, so the usual
palm/thumb-threshold libinput quirks (`AttrPalmPressureThreshold`,
`AttrThumbSizeThreshold`, …) cannot be used. `ModelTouchpadPhantomClicks=1`
is libinput's named workaround for this bug class — also applied today
to Dell XPS 15 9500 and LG gram 14 2023.
