import Foundation

public protocol AccessibilityPreferencesBackend: Sendable {
    func bool(forKey key: String) -> Bool?
    func int(forKey key: String) -> Int?
    mutating func setBool(_ value: Bool, forKey key: String) -> Bool
    mutating func setInt(_ value: Int, forKey key: String) -> Bool
    func synchronize() -> Bool
}

public struct InMemoryAccessibilityPreferencesBackend: AccessibilityPreferencesBackend, @unchecked Sendable {
    public var storage: [String: Any] = [:]

    public init() {}

    public func bool(forKey key: String) -> Bool? {
        storage[key] as? Bool
    }

    public func int(forKey key: String) -> Int? {
        if let value = storage[key] as? Int { return value }
        if let value = storage[key] as? Bool { return value ? 1 : 0 }
        return nil
    }

    public mutating func setBool(_ value: Bool, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }

    public mutating func setInt(_ value: Int, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }

    public func synchronize() -> Bool { true }
}

public struct CFAccessibilityPreferencesBackend: AccessibilityPreferencesBackend {
    private let domain = "com.apple.Accessibility"

    public init() {}

    public func bool(forKey key: String) -> Bool? {
        guard let value = CFPreferencesCopyValue(
            key as CFString,
            domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesCurrentHost
        ) else {
            return nil
        }
        if let number = value as? NSNumber { return number.boolValue }
        return value as? Bool
    }

    public func int(forKey key: String) -> Int? {
        guard let value = CFPreferencesCopyValue(
            key as CFString,
            domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesCurrentHost
        ) else {
            return nil
        }
        if let number = value as? NSNumber { return number.intValue }
        return value as? Int
    }

    public func setBool(_ value: Bool, forKey key: String) -> Bool {
        CFPreferencesSetValue(
            key as CFString,
            value as CFPropertyList,
            domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesCurrentHost
        )
        return true
    }

    public func setInt(_ value: Int, forKey key: String) -> Bool {
        CFPreferencesSetValue(
            key as CFString,
            value as CFPropertyList,
            domain as CFString,
            kCFPreferencesCurrentUser,
            kCFPreferencesCurrentHost
        )
        return true
    }

    public func synchronize() -> Bool {
        CFPreferencesAppSynchronize(domain as CFString)
    }
}
