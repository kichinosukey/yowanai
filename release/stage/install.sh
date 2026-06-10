#!/usr/bin/env bash
# Install Yowanai.app to /Applications (unsigned release).
# Run from the extracted zip folder:
#   xattr -cr . && bash install.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$DIR/Yowanai.app"
DEST="/Applications/Yowanai.app"

die() {
  echo "error: $*" >&2
  exit 1
}

[[ -d "$SRC" ]] || die "Yowanai.app が見つかりません。zip を展開したフォルダで実行してください。"

echo "Yowanai をインストールします..."
echo "  元: $SRC"
echo "  先: $DEST"

xattr -cr "$DIR" 2>/dev/null || true
ditto "$SRC" "$DEST"
xattr -cr "$DEST"

echo "完了。Yowanai を起動します..."
open "$DEST"
