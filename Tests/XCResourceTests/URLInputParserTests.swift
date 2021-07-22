
@testable import XCResource
import XCTest

import Foundation

final class URLInputParserTests: XCTestCase {

    var parser: URLInputParser!

    override func setUp() {
        parser = URLInputParser()
    }

    func testRemoteURL() throws {
        let remoteURL = "git@github.com:faberNovel/CodeSnippet_iOS.git"
        let url = try parser.absoluteURL(fromInput: "git@github.com:faberNovel/CodeSnippet_iOS.git")
        XCTAssertEqual(url.path , remoteURL)
    }

    func testCurrentDirectoryURL() throws {
        let target = URL(fileURLWithPath: "./tst")
        FileManager.default.createDirectoryIfNeeded(at: target)
        let url = try parser.absoluteURL(fromInput: "./tst")
        try? FileManager.default.removeItem(at: target)
        XCTAssertEqual(url.path, target.path)
    }

    func testHomeRelativeURL() throws {
        let url = try parser.absoluteURL(fromInput: "~")
        XCTAssertEqual(url, FileManager.default.homeDirectoryForCurrentUser)
    }

    func testAbsoluteURL() throws {
        let target = "/private/tmp/tst"
        let url = try parser.absoluteURL(fromInput: target)
        XCTAssertEqual(url.path, target)
    }
}
