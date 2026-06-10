import XCTest
@testable import YowanaiCore

final class MotionCuesTypesTests: XCTestCase {
    func testMotionPatternRawValues() {
        XCTAssertEqual(MotionPattern.regular.rawValue, 0)
        XCTAssertEqual(MotionPattern.dynamic.rawValue, 1)
        XCTAssertEqual(MotionPattern(rawValue: 1), .dynamic)
    }

    func testMotionPatternDisplayNames() {
        XCTAssertEqual(MotionPattern.regular.displayName, "標準")
        XCTAssertEqual(MotionPattern.dynamic.displayName, "ダイナミック")
    }

    func testMotionTintColorRange() {
        XCTAssertEqual(MotionTintColor.allCases.count, 6)
        XCTAssertNotNil(MotionTintColor(rawValue: 5))
        XCTAssertNil(MotionTintColor(rawValue: 99))
    }

    func testMotionTintColorDisplayNames() {
        XCTAssertEqual(MotionTintColor.grayscale.displayName, "グレイスケール")
        XCTAssertEqual(MotionTintColor.blue.displayName, "ブルー")
        XCTAssertEqual(MotionTintColor.green.displayName, "グリーン")
        XCTAssertEqual(MotionTintColor.yellow.displayName, "イエロー")
        XCTAssertEqual(MotionTintColor.orange.displayName, "オレンジ")
        XCTAssertEqual(MotionTintColor.red.displayName, "レッド")
    }
}
