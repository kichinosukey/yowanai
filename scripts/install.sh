#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$DIR/Yowanai.app"
DEST="/Applications/Yowanai.app"

[[ -d "$SRC" ]] || { echo "error: Yowanai.app not found beside install.sh" >&2; exit 1; }

xattr -cr "$DIR" 2>/dev/null || true
ditto "$SRC" "$DEST"
xattr -cr "$DEST"
open "$DEST"
echo "Installed to $DEST"
