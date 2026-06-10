import SwiftUI

struct StatusIconLabel: View {
    let isSupported: Bool
    let isEnabled: Bool

    var body: some View {
        if !isSupported {
            Image(systemName: "car.slash")
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.secondary)
        } else if isEnabled {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "car.fill")
                Circle()
                    .frame(width: 3, height: 3)
                    .offset(x: 2, y: -2)
            }
        } else {
            Image(systemName: "car")
        }
    }
}
