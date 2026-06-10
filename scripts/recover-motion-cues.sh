#!/usr/bin/env bash
# Reset Vehicle Motion Cues when dots stop appearing after third-party toggles.
set -euo pipefail

echo "Resetting Vehicle Motion Cues preferences..."
defaults write com.apple.Accessibility AXSMotionCuesEnabled -int 0
sleep 1
defaults write com.apple.Accessibility AXSMotionCuesEnabled -int 1
killall AccessibilityVisualsAgent 2>/dev/null || true
echo "Done. If dots still do not appear, log out and back in once."
