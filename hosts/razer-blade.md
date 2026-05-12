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
