
import Foundation

public class XCTemplateCLI {

    private let fileManager: XCTemplateFileManager
    private let downloader: XCTemplatesDownloader
    private let urlProvider: XCTemplateFolderURLProviding

    // MARK: - Life Cycle

    internal init(fileManager: XCTemplateFileManager,
                  downloader: XCTemplatesDownloader,
                  urlProvider: XCTemplateFolderURLProviding) {
        self.fileManager = fileManager
        self.downloader = downloader
        self.urlProvider = urlProvider
    }

    public convenience init() {
        self.init(
            fileManager: XCTemplateFileManager(
                fileManager: .default
            ),
            downloader: XCTemplatesDownloader(
                factory: XCTemplateFolderDownloadingStrategyFactory(fileManager: .default),
                fileManager: .default
            ),
            urlProvider: NamespaceFolderURLProvider()
        )
    }

    // MARK: - Public

    public func downloadTemplates(for namespace: XCTemplateNamespace,
                                  from source: XCTemplateSource) throws {
        try downloader.downloadTemplates(
            at: url(for: namespace),
            from: source
        )
    }

    public func removeTemplates(for namespace: XCTemplateNamespace) throws {
        try fileManager.removeTemplateFolder(at: url(for: namespace))
    }

    public func rootTemplateFolder() throws -> XCTemplateFolder {
        try fileManager.templateFolder(at: urlProvider.rootTemplateURL())
    }

    public func templateFolder(for namespace: XCTemplateNamespace) throws -> XCTemplateFolder {
        try fileManager.templateFolder(at: url(for: namespace))
    }

    public func openRootTemplateFolder() throws {
        try Shell().execute(.open(path: urlProvider.rootTemplateURL().path))
    }

    // MARK: - Private

    private func url(for namespace: XCTemplateNamespace) -> URL {
        urlProvider.url(for: namespace)
    }
}
