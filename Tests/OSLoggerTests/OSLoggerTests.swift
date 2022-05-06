import XCTest
@testable import OSLogger

final class OSLoggerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(OSLogger().text, "Hello, World!")
    }
}
