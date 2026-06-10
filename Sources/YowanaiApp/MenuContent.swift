import AppKit
import SwiftUI
import YowanaiCore

struct MenuContent: View {
    @Bindable var model: AppModel

    var body: some View {
        if let error = model.lastError {
            Text(error)
        }

        Toggle("Vehicle Motion Cues", isOn: Binding(
            get: { model.isEnabled },
            set: { model.setEnabled($0) }
        ))
        .disabled(!model.isSupported)

        Divider()

        Menu {
            Picker("パターン", selection: Binding(
                get: { model.pattern },
                set: { model.setPattern($0) }
            )) {
                ForEach(MotionPattern.allCases, id: \.self) { pattern in
                    Text(pattern.displayName).tag(pattern)
                }
            }
        } label: {
            Text("パターン")
        }
        .disabled(!model.isSupported)

        Menu {
            Picker("色", selection: Binding(
                get: { model.tintColor },
                set: { model.setTintColor($0) }
            )) {
                ForEach(MotionTintColor.allCases, id: \.self) { color in
                    Text(color.displayName).tag(color)
                }
            }
        } label: {
            Text("色")
        }
        .disabled(!model.isSupported)

        Toggle("大きいドット", isOn: Binding(
            get: { model.largerDots },
            set: { model.setLargerDots($0) }
        ))
        .disabled(!model.isSupported)

        Toggle("ドットを増やす", isOn: Binding(
            get: { model.moreDots },
            set: { model.setMoreDots($0) }
        ))
        .disabled(!model.isSupported)

        Divider()

        Button("システム設定で開く…") {
            SystemSettingsOpener.openMotionSettings()
        }

        Button("終了") {
            NSApplication.shared.terminate(nil)
        }
    }
}
