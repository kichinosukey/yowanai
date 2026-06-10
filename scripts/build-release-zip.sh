#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VERSION="${1:-0.1.0}"
STAGE="$ROOT/dist/release/stage"
ZIP="$ROOT/dist/release/Yowanai-${VERSION}-macos-unsigned.zip"

"$ROOT/scripts/build-app-bundle.sh" release

rm -rf "$STAGE"
mkdir -p "$STAGE"
ditto "$ROOT/dist/Yowanai.app" "$STAGE/Yowanai.app"
cp "$ROOT/release/stage/install.sh" "$STAGE/install.sh"
cp "$ROOT/release/stage/INSTALL.txt" "$STAGE/INSTALL.txt"
chmod +x "$STAGE/install.sh"

rm -f "$ZIP"
(cd "$STAGE" && zip -r "$ZIP" Yowanai.app install.sh INSTALL.txt)
shasum -a 256 "$ZIP" > "${ZIP}.sha256"

echo "Release: $ZIP"
cat "${ZIP}.sha256"
