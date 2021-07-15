
@testable import XCResource
import XCTest

import Foundation

final class XCResourceDownloaderTests: XCTestCase {

    private var url: URL!
    private var fileManager: FileManager!
    private var downloader: XCSnippetsDownloader!
    private var repository: GitRepository!

    override func setUp() {
        fileManager = .default
        url = FileManager.default.temporaryDirectory.appendingPathComponent("XCResourceDownloaderTests")
        downloader = XCSnippetsDownloader(
            fileManager: fileManager,
            snippetFileManager: XCSnippetFileManager(fileManager: fileManager),
            strategyFactory: XCSnippetDownloadingStrategyFactory(fileManager: fileManager)
        )
    }

    override func tearDown() {
        try? fileManager.removeItem(at: url)
    }

    func testDownload() throws {
        let originURL = url.appendingPathComponent("Origin")
        let originFolder = DynamicXCSnippetFolder(
            url: originURL,
            fileManager: fileManager
        )
        originFolder.clean()
        originFolder.generate()
        let repo = GitRepository(url: originURL)
        repo.initialize()
        let snippets: [DynamicXCSnippetFolder.Snippet] = [
            .basic(id: "A"),
            .basic(id: "B"),
        ]
        originFolder.create(snippets)
        originFolder.createRandomFile()
        repo.stageAll()
        repo.commit(message: "Initial commit")
        let destinationURL = url.appendingPathComponent("Dst")
        let destinationFolder = DynamicXCSnippetFolder(
            url: destinationURL,
            fileManager: fileManager
        )
        destinationFolder.generate()
        destinationFolder.create(.tagged(id: "C", tag: "A")) // should be replaced
        try downloader.downloadSnippets(
            at: destinationURL,
            from: .git(url: originURL, reference: GitReference("master"), folderPath: "/"),
            namespace: XCSnippetNamespace("A")
        )
        XCTAssertTrue(destinationFolder.onlyContains(.tagged(id: "A", tag: "A"), .tagged(id: "B", tag: "A")))
    }
}
