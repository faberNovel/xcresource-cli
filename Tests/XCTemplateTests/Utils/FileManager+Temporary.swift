
import Foundation

extension FileManager {

    func createDirectoryIfNeeded(at url: URL) {
        try? createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
