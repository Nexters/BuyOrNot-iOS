import XCTest
@testable import Core

final class LinkValidatorTests: XCTestCase {
    func testEmptyStringIsValid() {
        XCTAssertTrue(LinkValidator.isValid(""))
    }

    func testHttpURLIsValid() {
        XCTAssertTrue(LinkValidator.isValid("http://naver.com"))
    }

    func testHttpsURLIsValid() {
        XCTAssertTrue(LinkValidator.isValid("https://naver.com"))
    }

    func testHttpsURLWithPathAndQueryIsValid() {
        XCTAssertTrue(LinkValidator.isValid("https://www.naver.com/search?q=test"))
    }

    func testURLWithoutSchemeIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("naver.com"))
    }

    func testURLStartingWithWWWOnlyIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("www.naver.com"))
    }

    func testMisspelledSchemeIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("ttps://naver.com"))
    }

    func testHttpWithoutColonIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("http//naver.com"))
    }

    func testHttpsWithoutSlashesIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("https:naver.com"))
    }

    func testKoreanDomainIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("https://네이버.com"))
    }

    func testKoreanPathIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("https://naver.com/한글경로"))
    }

    func testURLWithSpaceInMiddleIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("https://naver .com"))
    }

    func testURLWithLeadingSpaceIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid(" https://naver.com"))
    }

    func testURLWithTrailingSpaceIsInvalid() {
        XCTAssertFalse(LinkValidator.isValid("https://naver.com "))
    }
}
