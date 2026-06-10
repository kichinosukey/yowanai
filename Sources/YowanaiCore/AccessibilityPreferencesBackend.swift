import Foundation

public protocol AccessibilityPreferencesBackend: Sendable {
    func bool(forKey key: String) -> Bool?
    func int(forKey key: String) -> Int?
    func setBool(_ value: Bool, forKey key: String) -> Bool
    func setInt(_ value: Int, forKey key: String) -> Bool
    func synchronize() -> Bool
}

/// Reference-type backend so `MotionCuesSettings` mutations are visible to test holders.
public final class InMemoryAccessibilityPreferencesBackend: AccessibilityPreferencesBackend, @unchecked Sendable {
    public var storage: [String: Any] = [:]

    public init() {}

    public func bool(forKey key: String) -> Bool? {
        if let value = storage[key] as? Bool { return value }
        if let value = storage[key] as? Int { return value != 0 }
        return nil
    }

    public func int(forKey key: String) -> Int? {
        if let value = storage[key] as? Int { return value }
        if let value = storage[key] as? Bool { return value ? 1 : 0 }
        return nil
    }

    public func setBool(_ value: Bool, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }

    public func setInt(_ value: Int, forKey key: String) -> Bool {
        storage[key] = value
        return true
    }

    public func synchronize() -> Bool { true }
}

/// Writes via `/usr/bin/defaults`. CFPreferences writes to `com.apple.Accessibility` do not
/// persist from third-party apps on macOS 26+, which left Vehicle Motion Cues stuck off.
public struct DefaultsAccessibilityPreferencesBackend: AccessibilityPreferencesBackend {
    private static let domain = "com.apple.Accessibility"
    private static let defaultsURL = URL(fileURLWithPath: "/usr/bin/defaults")

    public init() {}

    public func bool(forKey key: String) -> Bool? {
        guard let value = int(forKey: key) else { return nil }
        return value != 0
    }

    public func int(forKey key: String) -> Int? {
        guard let output = run(arguments: ["read", Self.domain, key]), !output.isEmpty else {
            return nil
        }
        return Int(output)
    }

    public func setBool(_ value: Bool, forKey key: String) -> Bool {
        write(key: key, flag: "-bool", value: value ? "YES" : "NO")
    }

    public func setInt(_ value: Int, forKey key: String) -> Bool {
        write(key: key, flag: "-int", value: String(value))
    }

    public func synchronize() -> Bool { true }

    private func write(key: String, flag: String, value: String) -> Bool {
        run(arguments: ["write", Self.domain, key, flag, value], checkSuccess: true) != nil
    }

    @discardableResult
    private func run(arguments: [String], checkSuccess: Bool = false) -> String? {
        let process = Process()
        process.executableURL = Self.defaultsURL
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return nil
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if checkSuccess, process.terminationStatus != 0 {
            return nil
        }

        if process.terminationStatus != 0 {
            return nil
        }

        return output
    }
}
