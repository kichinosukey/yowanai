import Foundation

public enum MotionPattern: Int, CaseIterable, Sendable {
    case regular = 0
    case dynamic = 1

    public var displayName: String {
        switch self {
        case .regular: return "標準"
        case .dynamic: return "ダイナミック"
        }
    }
}

public enum MotionTintColor: Int, CaseIterable, Sendable {
    case grayscale = 0
    case blue = 1
    case green = 2
    case yellow = 3
    case orange = 4
    case red = 5

    public var displayName: String {
        switch self {
        case .grayscale: return "グレイスケール"
        case .blue: return "ブルー"
        case .green: return "グリーン"
        case .yellow: return "イエロー"
        case .orange: return "オレンジ"
        case .red: return "レッド"
        }
    }
}

public enum MotionCuesPreferenceKey {
    public static let enabled = "AXSMotionCuesEnabled"
    public static let mode = "AXSMotionCuesMode"
    public static let tintColor = "AXSMotionCuesTintColor"
    public static let dotSize = "MotionCuesDotSize"
    public static let dotDensity = "MotionCuesDotDensity"
}
