
import Foundation

class XCTemplateFolderDownloadingStrategyFactory {

    let fileManager: FileManager
    let templateManager: XCTemplateFileManager

    init(fileManager: FileManager, templateManager: XCTemplateFileManager) {
        self.fileManager = fileManager
        self.templateManager = templateManager
    }

    func makeStrategy(source: XCTemplateSource) -> XCTemplateFolderDownloadingStrategy {
        switch source {
        case let .git(url, reference, folderPath):
            return GitSourceDownloadingStrategy(
                url: url,
                reference: reference,
                folderPath: folderPath,
                fileManager: fileManager,
                templateManager: templateManager
            )
        }
    }
}

struct GitSourceDownloadingStrategy: XCTemplateFolderDownloadingStrategy {

    let url: URL
    let reference: GitReference
    let folderPath: String
    let fileManager: FileManager
    let templateManager: XCTemplateFileManager

    // MARK: - XCTemplateFolderDownloadingStrategy

    func download(to destination: URL) throws {
        let tmp = try fileManager.createTemporarySubdirectory()
        defer {
            try? fileManager.removeItem(at: tmp)
        }
        try Shell().execute(
            .gitDownload(url: url.absoluteString, reference: reference, destionation: tmp.path)
        )
        let folder = try templateManager.templateFolder(at: tmp.appendingPathComponent(folderPath))
        try? fileManager.removeItem(at: destination)
        try fileManager.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
        try copy(folder, to: destination)
    }

    private func copy(_ folder: XCTemplateFolderFile, to destination: URL) throws {
        try folder.templates.forEach { template in
            try fileManager.copyItem(
                at: template.url,
                to: destination.appendingPathComponent(template.name)
            )
        }
        try folder.folders.forEach { folder in
            let url = destination.appendingPathComponent(folder.name)
            try fileManager.createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil
            )
            try copy(folder, to: url)
        }
    }
}
