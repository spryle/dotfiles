#!/usr/bin/env bash
# Apply system-level config from this directory into /etc.
# Mirrors the ./etc/ tree under /etc/. Idempotent — safe to re-run.
set -euo pipefail

SYSTEM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SYSTEM_DIR"

echo "[system] installing files into /etc (sudo required)"
find etc -type f -print0 | while IFS= read -r -d '' rel; do
    sudo install -Dm644 "$rel" "/$rel"
    echo "  /$rel"
done

# Restart services whose config we just dropped in.
# Add a branch here when introducing a new subtree under etc/.
if [[ -d etc/systemd/resolved.conf.d ]]; then
    echo "[system] restarting systemd-resolved"
    sudo systemctl restart systemd-resolved
fi

echo "[system] done"
