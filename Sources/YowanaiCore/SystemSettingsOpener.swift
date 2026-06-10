import AppKit

public enum SystemSettingsOpener {
    public static func openMotionSettings() {
        let candidates = [
            "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?Motion",
            "x-apple.systempreferences:com.apple.Accessibility-Settings.extension",
        ]
        for candidate in candidates {
            if let url = URL(string: candidate), NSWorkspace.shared.open(url) {
                return
            }
        }
    }
}
