import Foundation
import Observation
import YowanaiCore

@Observable
final class AppModel {
    private(set) var isSupported = DeviceSupport.isSupported()
    private(set) var lastError: String?
    private var settings = MotionCuesSettings()

    var isEnabled: Bool { settings.isEnabled }
    var pattern: MotionPattern { settings.pattern }
    var tintColor: MotionTintColor { settings.tintColor }
    var largerDots: Bool { settings.largerDots }
    var moreDots: Bool { settings.moreDots }

    func refresh() {
        settings = MotionCuesSettings()
        settings.load()
        lastError = nil
    }

    func setEnabled(_ enabled: Bool) {
        guard isSupported else { return }
        settings.isEnabled = enabled
        do {
            try settings.saveEnabled()
            lastError = nil
        } catch {
            lastError = "設定の変更に失敗しました"
            refresh()
        }
    }

    func setPattern(_ pattern: MotionPattern) {
        mutateAppearance { $0.pattern = pattern }
    }

    func setTintColor(_ color: MotionTintColor) {
        mutateAppearance { $0.tintColor = color }
    }

    func setLargerDots(_ enabled: Bool) {
        mutateAppearance { $0.largerDots = enabled }
    }

    func setMoreDots(_ enabled: Bool) {
        mutateAppearance { $0.moreDots = enabled }
    }

    private func mutateAppearance(_ change: (inout MotionCuesSettings) -> Void) {
        guard isSupported else { return }
        change(&settings)
        do {
            try settings.saveAppearance()
            lastError = nil
        } catch {
            lastError = "設定の変更に失敗しました"
            refresh()
        }
    }
}
