
import XCTemplate
import Foundation

extension FileManager: XCTemplateFolderURLProviding {

    public func url(for folder: XCTemplateFolder) -> URL {
        let url: URL
        switch folder {
        case let .templates(namespace):
            url = temporaryDirectory.appendingPathComponent(namespace)
        case .workingDirectory:
            url = temporaryDirectory.appendingPathComponent("Working")
        case .xcodeDestination:
            url = temporaryDirectory.appendingPathComponent("XcodeDestination")
        }
        createIfNeededDirectory(at: url)
        return url
    }

    func createIfNeededDirectory(at url: URL) {
        try? createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
}
