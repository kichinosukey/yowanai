# Preference Mapping

Vehicle Motion Cues settings in the `com.apple.Accessibility` domain.

**Investigation environment:** Mac14,5, macOS 27.0 (build 26A5353q)  
**Method:** `defaults read` / `defaults write` round-trip (System Settings GUI not used in this session). UI labels taken from `AccessibilitySettingsExtension.appex` → `Localizable.loctable` (`en`, `ja`). Original preference values were saved before probing and restored afterward.

## Baseline (this Mac, pre-probe)

| Key | Value | Type |
|-----|-------|------|
| `AXSMotionCuesEnabled` | `1` | integer (bool-like) |
| `AXSMotionCuesMode` | `1` | integer |
| `AXSMotionCuesTintColor` | `1` | integer |
| `MotionCuesDotSize` | `1` | boolean |
| `MotionCuesDotDensity` | `2` | integer |

`defaults read com.apple.Accessibility <key1> <key2> …` returns only the first key when multiple keys are passed; read keys individually.

## AXSMotionCuesEnabled

Master ON/OFF for Vehicle Motion Cues.

| Value | System Settings label (en) | System Settings label (ja) |
|-------|---------------------------|---------------------------|
| `0` / `false` | Off | オフ |
| `1` / `true` | On | オン |

**Type:** integer in plist (`defaults read-type` reports integer; use `-bool` for writes).

## AXSMotionCuesMode

Pattern selection (**Pattern** / パターン).

| Value | System Settings label (en) | System Settings label (ja) | Notes |
|-------|---------------------------|---------------------------|-------|
| `0` | Regular | 標準 | Localization key: `display.motionCues.pattern.default` |
| `1` | Dynamic | ダイナミック | Localization key: `display.motionCues.pattern.dynamic` |
| `2` | — | — | Accepts `defaults write`; no third Pattern option in System Settings UI |

Apple Support describes only Regular and Dynamic. Treat `2` as undocumented; do not expose in Yowanai UI unless a future macOS version adds a third pattern.

## AXSMotionCuesTintColor

Dot color selection (**Color** / カラー). Valid range: `0`–`5` (all values round-trip via `defaults write`).

| Value | System Settings label (en) | System Settings label (ja) | Verification |
|-------|---------------------------|---------------------------|--------------|
| `0` | Grayscale | グレイスケール | Inferred — confirm swatch order in System Settings |
| `1` | Blue | ブルー | Inferred — matches baseline on this Mac |
| `2` | Green | グリーン | Inferred — confirm swatch order in System Settings |
| `3` | Yellow | イエロー | Inferred — confirm swatch order in System Settings |
| `4` | Orange | オレンジ | Inferred — confirm swatch order in System Settings |
| `5` | Red | レッド | Inferred — confirm swatch order in System Settings |

**Localization note:** `AccessibilitySettingsExtension` also defines `display.motionCues.color.purple` (Purple / パープル), but only six tint indices (`0`–`5`) exist in preferences. Purple may be omitted on Mac or share an index — verify in **System Settings → Accessibility → Motion → Vehicle Motion Cues → Customize Appearance**.

**Inference basis:** Grayscale-first ordering is standard for this control; baseline `AXSMotionCuesTintColor=1` is consistent with Blue as the second swatch. Reconcile index order in System Settings before shipping Task 3 display names if swatches differ.

## MotionCuesDotSize

**Larger dots** / より大きな点.

| Value | System Settings label (en) | System Settings label (ja) |
|-------|---------------------------|---------------------------|
| `0` / `false` | Larger dots — Off | より大きな点 — オフ |
| `1` / `true` | Larger dots — On | より大きな点 — オン |

**Type:** boolean.

## MotionCuesDotDensity

**More dots** / より多くの点. The UI exposes a single toggle; intermediate values are writable but not separately labeled.

| Value | More dots toggle (this Mac) | Notes |
|-------|----------------------------|-------|
| `0` | Off | Confirmed via `defaults write` |
| `1` | — | Writable; no distinct UI label |
| `2` | On | Confirmed via `defaults write`; matches baseline |
| `3` | — | Writable; no distinct UI label |

**Yowanai mapping (from design spec):** `moreDots ? 2 : 0`.

## Related keys (do not write from Yowanai)

| Key | Type | Purpose |
|-----|------|---------|
| `AXSMotionCuesActive` | integer | Runtime active state (read-only for app logic) |
| `AXSMotionCuesShouldShowBanner` | integer | Banner display state |
| `ReduceMotionEnabled` | integer | Separate **Reduce motion** setting; unrelated to Vehicle Motion Cues |

## Probe commands (reference)

```bash
# Read baseline
for key in AXSMotionCuesEnabled AXSMotionCuesMode AXSMotionCuesTintColor MotionCuesDotSize MotionCuesDotDensity; do
  echo -n "$key: "; defaults read com.apple.Accessibility "$key"
done

# Pattern values
for v in 0 1 2; do
  defaults write com.apple.Accessibility AXSMotionCuesMode -int "$v"
  echo "mode $v -> $(defaults read com.apple.Accessibility AXSMotionCuesMode)"
done

# Tint values
for v in 0 1 2 3 4 5; do
  defaults write com.apple.Accessibility AXSMotionCuesTintColor -int "$v"
  echo "tint $v -> $(defaults read com.apple.Accessibility AXSMotionCuesTintColor)"
done

# Larger dots
defaults write com.apple.Accessibility MotionCuesDotSize -bool false  # -> 0
defaults write com.apple.Accessibility MotionCuesDotSize -bool true   # -> 1

# Density
for v in 0 1 2 3; do
  defaults write com.apple.Accessibility MotionCuesDotDensity -int "$v"
  echo "density $v -> $(defaults read com.apple.Accessibility MotionCuesDotDensity)"
done
```

Always save and restore user values after probing.
