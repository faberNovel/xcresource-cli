
import Foundation
import XCTest
@testable import XCTemplate

extension FileManager {

    func createDirectoryIfNeeded(at url: URL) {
        try? createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    func assertDirectoryContains(_ testFiles: [String], at url: URL) throws {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url)
            print(urls)
            let fileNames = urls.map { $0.lastPathComponent }
            XCTAssertEqual(urls.count, testFiles.count)
            fileNames.forEach { XCTAssertTrue(testFiles.contains($0)) }
        } catch {
            XCTFail()
        }
    }
}
