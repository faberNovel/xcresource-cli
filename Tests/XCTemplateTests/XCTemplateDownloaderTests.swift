
@testable import XCTemplate
import XCTest

final class XCTemplateDownloaderTests: XCTestCase {

    private var fileManager: FileManager!
    private var templateManager: XCTemplateFileManager!
    private var workingUrl: URL!
    private var templatesUrl: URL!
    private var repository: GitRepository!

    override func setUp() {
        fileManager = .default
        workingUrl = try! fileManager.createTemporarySubdirectory()
        templatesUrl = workingUrl.appendingPathComponent("Templates")
        repository = GitRepository(url: workingUrl.appendingPathComponent("Repository"))
        repository.initialize()
        templateManager = XCTemplateFileManager(fileManager: fileManager)
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
            fileManager: fileManager,
            templateManager: templateManager
        )
        try strategy.download(to: templatesUrl)
        try expectTemplates(at: folder.rootUrl, equals: templatesUrl)
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
            fileManager: fileManager,
            templateManager: templateManager
        )
        try strategy.download(to: templatesUrl)
        try expectTemplates(at: folder.rootUrl, equals: templatesUrl)
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
            fileManager: fileManager,
            templateManager: templateManager 
        )
        try strategy.download(to: templatesUrl)
        try expectTemplates(at: folder.rootUrl, equals: templatesUrl)
    }

    private func expectTemplates(at origin: URL, equals destination: URL) throws {
        let lhs = try templateManager.templateFolder(at: origin)
        let rhs = try templateManager.templateFolder(at: destination)
        XCTAssertTrue(rhs.hasSameContent(as: lhs))
    }

    static var allTests = [
        ("testBranchGitDownload", testBranchGitDownload),
        ("testTagDownload", testTagDownload),
        ("testDeepFolderDownload", testDeepFolderDownload),
    ]
}

private extension XCTemplateFolderFile {

    func hasSameContent(as other: XCTemplateFolderFile) -> Bool {
        guard folders.count == other.folders.count else { return false }
        let foldersHaveSameContent = zip(other.folders, folders).allSatisfy { $0.hasSameContent(as: $1) && $0.name == $1.name }
        let templatesHaveSameContent = zip(other.templates, templates).allSatisfy { $0.hasSameContent(as: $1) }
        return templatesHaveSameContent && foldersHaveSameContent
    }
}

private extension XCTemplateFile {

    func hasSameContent(as other: XCTemplateFile) -> Bool {
        name == other.name
    }
}

private extension FileManager {

    func templateContentEquals(atPath lhs: String, andPath rhs: String) -> Bool {
        let lhsEnumerator = enumerator(atPath: lhs)
        let rhsEnumerator = enumerator(atPath: rhs)
        while let lhs = lhsEnumerator?.nextObject() as? String, let rhs = rhsEnumerator?.nextObject() as? String, lhs == rhs {}
        return lhsEnumerator?.nextObject() == nil && rhsEnumerator?.nextObject() == nil
    }
}
