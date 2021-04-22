
import Foundation

extension FileManager {

    func createTemporarySubdirectory() throws -> URL {
        let url = temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
        return url
    }
}
