import AppKit
import SwiftUI
import YowanaiCore

@main
struct YowanaiApp: App {
    @State private var model = AppModel()

    init() {
        enforceSingleInstance()
        if ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 26 {
            DispatchQueue.main.async {
                NSAlert(messageText: "Yowanai は macOS 26 以降が必要です").runModal()
            }
        }
    }

    var body: some Scene {
        MenuBarExtra {
            MenuContent(model: model)
                .onAppear { model.refresh() }
        } label: {
            StatusIconLabel(
                isSupported: model.isSupported,
                isEnabled: model.isEnabled
            )
        }
        .menuBarExtraStyle(.menu)
    }

    private func enforceSingleInstance() {
        let bundleID = Bundle.main.bundleIdentifier ?? "local.yowanai"
        let others = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
            .filter { $0 != .current }
        if let existing = others.first {
            existing.activate()
            exit(0)
        }
    }
}

private extension NSAlert {
    convenience init(messageText: String) {
        self.init()
        self.messageText = messageText
        self.addButton(withTitle: "OK")
    }
}
