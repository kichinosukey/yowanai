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
        mutate { $0.isEnabled = enabled }
    }

    func setPattern(_ pattern: MotionPattern) {
        mutate { $0.pattern = pattern }
    }

    func setTintColor(_ color: MotionTintColor) {
        mutate { $0.tintColor = color }
    }

    func setLargerDots(_ enabled: Bool) {
        mutate { $0.largerDots = enabled }
    }

    func setMoreDots(_ enabled: Bool) {
        mutate { $0.moreDots = enabled }
    }

    private func mutate(_ change: (inout MotionCuesSettings) -> Void) {
        guard isSupported else { return }
        change(&settings)
        do {
            try settings.save()
            lastError = nil
        } catch {
            lastError = "設定の変更に失敗しました"
            refresh()
        }
    }
}
