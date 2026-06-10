import AppKit
import Foundation
import Observation
import YowanaiCore

@MainActor
@Observable
final class AppModel {
    private(set) var isSupported = DeviceSupport.isSupported()
    private(set) var lastError: String?

    private(set) var isEnabled = false
    private(set) var pattern = MotionPattern.regular
    private(set) var tintColor = MotionTintColor.grayscale
    private(set) var largerDots = false
    private(set) var moreDots = false

    private var settings = MotionCuesSettings()

    init() {
        reloadFromSystem()
        NotificationCenter.default.addObserver(
            forName: NSApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.reloadFromSystem()
            }
        }
    }

    func reloadFromSystem() {
        settings.load()
        isEnabled = settings.isEnabled
        pattern = settings.pattern
        tintColor = settings.tintColor
        largerDots = settings.largerDots
        moreDots = settings.moreDots
        lastError = nil
    }

    func setEnabled(_ enabled: Bool) {
        guard isSupported else { return }
        settings.isEnabled = enabled
        do {
            try settings.saveEnabled()
            isEnabled = enabled
            lastError = nil
        } catch {
            lastError = "設定の変更に失敗しました"
            reloadFromSystem()
        }
    }

    func setPattern(_ value: MotionPattern) {
        mutateAppearance { $0.pattern = value }
    }

    func setTintColor(_ value: MotionTintColor) {
        mutateAppearance { $0.tintColor = value }
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
            pattern = settings.pattern
            tintColor = settings.tintColor
            largerDots = settings.largerDots
            moreDots = settings.moreDots
            lastError = nil
        } catch {
            lastError = "設定の変更に失敗しました"
            reloadFromSystem()
        }
    }
}
