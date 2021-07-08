
import Foundation

protocol XCSnippetDownloadingStrategy {
    func download(to destination: URL) throws
}

class XCSnippetDownloadingStrategyFactory {

    let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func makeStrategy(source: XCSnippetSource) -> XCSnippetDownloadingStrategy {
        switch source {
        case let .git(url, reference, folderPath):
            return GitSourceSnippetDownloadingStrategy(
                url: url,
                reference: reference,
                folderPath: folderPath,
                fileManager: fileManager
            )
        }
    }
}

struct GitSourceSnippetDownloadingStrategy: XCSnippetDownloadingStrategy {

    let url: URL
    let reference: GitReference
    let folderPath: String
    let fileManager: FileManager

    // MARK: - XCSnippetDownloadingStrategy

    func download(to destination: URL) throws {
        let tmp = try fileManager.createTemporarySubdirectory()
        defer {
            try? fileManager.removeItem(at: tmp)
        }
        try Shell().execute(
            .gitDownload(url: url.absoluteString, reference: reference, destionation: tmp.path)
        )
        let snippetsDirectoryURL = tmp.appendingPathComponent(folderPath)
        let snippets = try fileManager.contentsOfDirectory(atPath: snippetsDirectoryURL.path)
        for path in snippets {
            let url = URL(fileURLWithPath: path)
            try fileManager.copyItem(at: url, to: tmp.appendingPathComponent(url.lastPathComponent))
        }
    }
}
