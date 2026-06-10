#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/dist/Yowanai.app"
DEST="/Applications/Yowanai.app"

[[ -d "$SRC" ]] || { echo "error: Yowanai.app not found beside install.sh" >&2; exit 1; }

xattr -cr "$ROOT" 2>/dev/null || true
ditto "$SRC" "$DEST"
xattr -cr "$DEST"
open "$DEST"
echo "Installed to $DEST"
