import Foundation

public enum DeviceSupport {
    private static let blockedModels: Set<String> = [
        "MacBookAir10,1",  // M1 Air
        "MacBookPro17,1",  // 13" M1 Pro
        "MacBookAir9,1",
        "MacBookAir8,1",
        "MacBookPro16,1",
        "MacBookPro16,2",
        "MacBookPro15,1",
        "MacBookPro15,2",
        "MacBookPro15,3",
        "MacBookPro15,4",
    ]

    public static func isSupported(
        modelIdentifier: String = currentModelIdentifier(),
        osMajor: Int = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
    ) -> Bool {
        guard osMajor >= 26 else { return false }
        guard modelIdentifier.hasPrefix("MacBook") else { return false }
        if modelIdentifier.localizedCaseInsensitiveContains("Neo") { return false }
        return !blockedModels.contains(modelIdentifier)
    }

    public static func currentModelIdentifier() -> String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }
}
