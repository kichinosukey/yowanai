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

        Text("パターン")
            .disabled(!model.isSupported)
        ForEach(MotionPattern.allCases, id: \.self) { value in
            Button {
                model.setPattern(value)
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                        .opacity(model.pattern == value ? 1 : 0)
                    Text(value.displayName)
                }
            }
            .disabled(!model.isSupported)
        }

        Divider()

        Text("色")
            .disabled(!model.isSupported)
        ForEach(MotionTintColor.allCases, id: \.self) { value in
            Button {
                model.setTintColor(value)
            } label: {
                HStack {
                    Image(systemName: "checkmark")
                        .opacity(model.tintColor == value ? 1 : 0)
                    Text(value.displayName)
                }
            }
            .disabled(!model.isSupported)
        }

        Divider()

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
