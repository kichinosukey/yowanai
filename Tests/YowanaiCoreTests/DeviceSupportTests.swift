import XCTest
@testable import YowanaiCore

final class DeviceSupportTests: XCTestCase {
    func testBlockedModelsAreUnsupported() {
        XCTAssertFalse(DeviceSupport.isSupported(modelIdentifier: "MacBookAir10,1", osMajor: 26))
        XCTAssertFalse(DeviceSupport.isSupported(modelIdentifier: "MacBookPro17,1", osMajor: 26))
    }

    func testRecentMacBookProIsSupported() {
        XCTAssertTrue(DeviceSupport.isSupported(modelIdentifier: "Mac14,5", osMajor: 26))
    }

    func testOldMacOSIsUnsupported() {
        XCTAssertFalse(DeviceSupport.isSupported(modelIdentifier: "Mac14,5", osMajor: 25))
    }
}
