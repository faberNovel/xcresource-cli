
@testable import XCTemplate
import XCTest

final class XCTemplateDownloaderTests: XCTestCase {

    private var fileManager: FileManager!
    private var workingUrl: URL!
    private var templatesUrl: URL!
    private var repository: GitRepository!

    override func setUp() {
        fileManager = .default
        workingUrl = try! fileManager.createTemporarySubdirectory()
        templatesUrl = workingUrl.appendingPathComponent("Templates")
        repository = GitRepository(url: workingUrl.appendingPathComponent("Repository"))
        repository.initialize()
    }

    override func tearDown() {
        try? fileManager.removeItem(at: workingUrl)
    }

    func testBranchGitDownload() throws {
        let reference = GitReference("target-branch")
        repository.checkoutNewBranch(reference.name)
        let templatesPath = "/"
        let folder = DynamicXCTemplateFolder(
            url: repository.url.appendingPathComponent(templatesPath),
            fileManager: fileManager
        )
        folder.createTemplate(named: "Template1")
        folder.createTemplate(named: "Template2")
        repository.stageAll()
        repository.commit(message: "My templates")
        let strategy = GitSourceDownloadingStrategy(
            url: repository.url,
            reference: reference,
            folderPath: templatesPath,
            fileManager: fileManager
        )
        try strategy.download(to: templatesUrl)
        XCTAssertTrue(fileManager.contentsEqual(atPath: folder.rootUrl.path, andPath: templatesUrl.path))
    }

    func testTagDownload() throws {
        let reference = GitReference("target-tag")
        let templatesPath = "Templates"
        let folder = DynamicXCTemplateFolder(
            url: repository.url.appendingPathComponent(templatesPath),
            fileManager: fileManager
        )
        folder.createTemplate(named: "Template1")
        folder.createTemplate(named: "Template2")
        repository.stageAll()
        repository.commit(message: "My templates")
        repository.tag(reference.name)
        let strategy = GitSourceDownloadingStrategy(
            url: repository.url,
            reference: reference,
            folderPath: templatesPath,
            fileManager: fileManager
        )
        try strategy.download(to: templatesUrl)
        XCTAssertTrue(fileManager.contentsEqual(atPath: folder.rootUrl.path, andPath: templatesUrl.path))
    }

    func testDeepFolderDownload() throws {
        let reference = GitReference("target-branch")
        repository.checkoutNewBranch(reference.name)
        let templatesPath = "Path/To/Templates"
        let folder = DynamicXCTemplateFolder(
            url: repository.url.appendingPathComponent(templatesPath),
            fileManager: fileManager
        )
        folder.createTemplate(named: "Templates2")
        folder.createTemplate(named: "Templates1")
        repository.stageAll()
        repository.commit(message: "My templates")
        let strategy = GitSourceDownloadingStrategy(
            url: repository.url,
            reference: reference,
            folderPath: templatesPath,
            fileManager: fileManager
        )
        try strategy.download(to: templatesUrl)
        XCTAssertTrue(fileManager.contentsEqual(atPath: folder.rootUrl.path, andPath: templatesUrl.path))
    }

    static var allTests = [
        ("testBranchGitDownload", testBranchGitDownload),
        ("testTagDownload", testTagDownload),
        ("testDeepFolderDownload", testDeepFolderDownload),
    ]
}
