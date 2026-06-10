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

    private static let desktopPrefixes = ["Macmini", "MacStudio", "MacPro", "iMac", "Xserve"]

    public static func isSupported(
        modelIdentifier: String = currentModelIdentifier(),
        osMajor: Int = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
    ) -> Bool {
        guard osMajor >= 26 else { return false }
        if modelIdentifier.localizedCaseInsensitiveContains("Neo") { return false }
        if blockedModels.contains(modelIdentifier) { return false }
        return isPortableMac(modelIdentifier)
    }

    static func isPortableMac(_ modelIdentifier: String) -> Bool {
        if modelIdentifier.hasPrefix("MacBook") { return true }
        if desktopPrefixes.contains(where: { modelIdentifier.hasPrefix($0) }) { return false }
        return modelIdentifier.range(of: #"^Mac\d+,\d+$"#, options: .regularExpression) != nil
    }

    public static func currentModelIdentifier() -> String {
        var size = 0
        sysctlbyname("hw.model", nil, &size, nil, 0)
        var model = [CChar](repeating: 0, count: size)
        sysctlbyname("hw.model", &model, &size, nil, 0)
        return String(cString: model)
    }
}
