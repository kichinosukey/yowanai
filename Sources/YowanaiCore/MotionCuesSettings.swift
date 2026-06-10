import Foundation

public struct MotionCuesSettings: Sendable {
    public var isEnabled = false
    public var pattern = MotionPattern.regular
    public var tintColor = MotionTintColor.grayscale
    public var largerDots = false
    public var moreDots = false

    private var backend: AccessibilityPreferencesBackend

    public init(backend: AccessibilityPreferencesBackend = CFAccessibilityPreferencesBackend()) {
        self.backend = backend
    }

    public mutating func load() {
        isEnabled = backend.bool(forKey: MotionCuesPreferenceKey.enabled) ?? false
        if let raw = backend.int(forKey: MotionCuesPreferenceKey.mode),
           let pattern = MotionPattern(rawValue: raw) {
            self.pattern = pattern
        }
        if let raw = backend.int(forKey: MotionCuesPreferenceKey.tintColor),
           let tint = MotionTintColor(rawValue: raw) {
            self.tintColor = tint
        }
        largerDots = backend.bool(forKey: MotionCuesPreferenceKey.dotSize) ?? false
        let density = backend.int(forKey: MotionCuesPreferenceKey.dotDensity) ?? 0
        moreDots = density > 0
    }

    public mutating func save() throws {
        guard backend.setBool(isEnabled, forKey: MotionCuesPreferenceKey.enabled),
              backend.setInt(pattern.rawValue, forKey: MotionCuesPreferenceKey.mode),
              backend.setInt(tintColor.rawValue, forKey: MotionCuesPreferenceKey.tintColor),
              backend.setBool(largerDots, forKey: MotionCuesPreferenceKey.dotSize),
              backend.setInt(moreDots ? 2 : 0, forKey: MotionCuesPreferenceKey.dotDensity),
              backend.synchronize()
        else {
            throw MotionCuesSettingsError.saveFailed
        }
    }
}

public enum MotionCuesSettingsError: Error, Equatable {
    case saveFailed
}
