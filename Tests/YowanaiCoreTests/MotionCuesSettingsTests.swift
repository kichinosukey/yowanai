import XCTest
@testable import YowanaiCore

final class MotionCuesSettingsTests: XCTestCase {
    func testInMemoryBackendRoundTrip() {
        var backend = InMemoryAccessibilityPreferencesBackend()
        backend.storage["AXSMotionCuesEnabled"] = true
        backend.storage["AXSMotionCuesMode"] = 1
        backend.storage["AXSMotionCuesTintColor"] = 3
        backend.storage["MotionCuesDotSize"] = true
        backend.storage["MotionCuesDotDensity"] = 2

        XCTAssertEqual(backend.bool(forKey: "AXSMotionCuesEnabled"), true)
        XCTAssertEqual(backend.int(forKey: "AXSMotionCuesMode"), 1)
        XCTAssertTrue(backend.setBool(false, forKey: "AXSMotionCuesEnabled"))
        XCTAssertEqual(backend.bool(forKey: "AXSMotionCuesEnabled"), false)
        XCTAssertTrue(backend.synchronize())
    }
}
