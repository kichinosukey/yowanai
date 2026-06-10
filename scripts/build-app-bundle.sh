#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

CONFIG="${1:-debug}"
PRODUCT="YowanaiApp"
APP_NAME="Yowanai"
DIST="$ROOT/dist/$APP_NAME.app"

echo "Building ($CONFIG)..."
if [[ "$CONFIG" == "release" ]]; then
  swift build -c release
  BIN="$ROOT/.build/release/$PRODUCT"
else
  swift build
  BIN="$ROOT/.build/debug/$PRODUCT"
fi

rm -rf "$DIST"
mkdir -p "$DIST/Contents/MacOS" "$DIST/Contents/Resources"

cp "$ROOT/App/Info.plist" "$DIST/Contents/Info.plist"
cp "$BIN" "$DIST/Contents/MacOS/$APP_NAME"
chmod +x "$DIST/Contents/MacOS/$APP_NAME"
cp "$ROOT/App/Icon/AppIcon.icns" "$DIST/Contents/Resources/AppIcon.icns"

codesign --force --sign - --deep "$DIST"
codesign --verify --deep --strict "$DIST"

echo "Built: $DIST"
