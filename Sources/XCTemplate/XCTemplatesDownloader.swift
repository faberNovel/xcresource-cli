
import Foundation

class XCTemplatesDownloader {

    let factory: XCTemplateFolderDownloadingStrategyFactory
    let fileManager: FileManager

    // MARK: - Life Cycle

    init(factory: XCTemplateFolderDownloadingStrategyFactory,
         fileManager: FileManager) {
        self.factory = factory
        self.fileManager = fileManager
    }

    // MARK: - Public

    func downloadTemplates(at destination: URL, from source: XCTemplateSource) throws {
        let tmp = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer {
            try? fileManager.removeItem(at: tmp)
        }
        try fileManager.createDirectory(at: tmp, withIntermediateDirectories: false, attributes: nil)
        try factory.strategy(source: source).download(to: tmp)
        let templateUrls = try fileManager.contentsOfDirectory(
            at: tmp,
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
        try? fileManager.removeItem(at: destination)
        try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
        try templateUrls.forEach { folder in
            let folderDestination = destination.appendingPathComponent(folder.lastPathComponent)
            try fileManager.copyItem(at: folder, to: folderDestination)
        }
    }
}
