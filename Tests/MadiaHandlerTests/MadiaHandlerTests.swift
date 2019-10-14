import XCTest
@testable import MadiaHandler

final class MadiaHandlerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MadiaHandler().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
