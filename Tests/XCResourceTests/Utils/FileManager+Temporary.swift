
import Foundation
import XCTest
@testable import XCResource

extension FileManager {

    func createDirectoryIfNeeded(at url: URL) {
        try? createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    func assertDirectoryContains(_ testFiles: [String], at url: URL) {
        XCTAssertTrue(directoryOnlyContains(testFiles, at: url))
    }

    func directoryOnlyContains(_ testFiles: [String], at url: URL) -> Bool {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url)
            let fileNames = urls.map { $0.lastPathComponent }
            guard urls.count == testFiles.count else { return false }
            for filename in fileNames {
                guard testFiles.contains(filename) else { return false }
            }
            return true
        } catch {
            return false
        }
    }
}
