import XCTest
@testable import CameraRollManager

final class CameraRollManagerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CameraRollManager().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
