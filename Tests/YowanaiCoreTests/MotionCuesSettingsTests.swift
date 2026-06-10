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
        XCTAssertTrue(backend.setInt(0, forKey: "AXSMotionCuesEnabled"))
        XCTAssertEqual(backend.int(forKey: "AXSMotionCuesEnabled"), 0)
        XCTAssertTrue(backend.synchronize())
    }

    func testLoadAndSaveRoundTrip() throws {
        var backend = InMemoryAccessibilityPreferencesBackend()
        backend.storage = [
            "AXSMotionCuesEnabled": true,
            "AXSMotionCuesMode": 1,
            "AXSMotionCuesTintColor": 2,
            "MotionCuesDotSize": true,
            "MotionCuesDotDensity": 2,
        ]
        var settings = MotionCuesSettings(backend: backend)
        settings.load()

        XCTAssertTrue(settings.isEnabled)
        XCTAssertEqual(settings.pattern, .dynamic)
        XCTAssertEqual(settings.tintColor.rawValue, 2)
        XCTAssertTrue(settings.largerDots)
        XCTAssertTrue(settings.moreDots)

        settings.isEnabled = false
        settings.pattern = .regular
        settings.moreDots = false
        try settings.save()

        XCTAssertEqual(backend.int(forKey: "AXSMotionCuesEnabled"), 0)
        XCTAssertEqual(backend.int(forKey: "AXSMotionCuesMode"), 0)
        XCTAssertEqual(backend.int(forKey: "MotionCuesDotDensity"), 0)
    }
}
