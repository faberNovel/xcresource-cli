
import Foundation

class XCTemplateFolderDownloadingStrategyFactory {

    let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func strategy(source: XCTemplateSource) -> XCTemplateFolderDownloadingStrategy {
        switch source {
        case let .git(url, reference, folderPath):
            return GitSourceDownloadingStrategy(
                url: url,
                reference: reference,
                folderPath: folderPath,
                fileManager: fileManager
            )
        }
    }
}

struct GitSourceDownloadingStrategy: XCTemplateFolderDownloadingStrategy {

    let url: URL
    let reference: GitReference
    let folderPath: String
    let fileManager: FileManager

    // MARK: - XCTemplateFolderDownloadingStrategy

    func download(to destination: URL) throws {
        let tmp = try fileManager.createTemporarySubdirectory()
        defer {
            try? fileManager.removeItem(at: tmp)
        }
        try Shell().execute(
            .gitDownload(url: url.absoluteString, reference: reference, destionation: tmp.path)
        )
        let templateUrls = try fileManager.contentsOfDirectory(
            at: url.appendingPathComponent(folderPath),
            includingPropertiesForKeys: nil,
            options: .skipsHiddenFiles
        )
        try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
        try templateUrls.forEach { folder in
            let folderDestination = destination.appendingPathComponent(folder.lastPathComponent)
            try fileManager.copyItem(at: folder, to: folderDestination)
        }
    }
}
