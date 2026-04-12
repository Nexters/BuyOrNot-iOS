import XCTest
@testable import Core

final class LinkValidatorTests: XCTestCase {
    func testIsValidReturnsTrueTemporarily() {
        let sut = LinkValidator()

        let result = sut.isValid("invalid-url")

        XCTAssertTrue(result)
    }
}
