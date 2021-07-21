
import Foundation

public class XCTemplateLibrary {

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
        let fileManager = XCTemplateFileManager(
            fileManager: .default
        )
        self.init(
            fileManager: fileManager,
            downloader: XCTemplatesDownloader(
                factory: XCTemplateFolderDownloadingStrategyFactory(
                    fileManager: .default,
                    templateManager: fileManager
                )
            ),
            urlProvider: NativeNamespaceFolderURLProvider()
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
        let folder = try fileManager.templateFolder(at: urlProvider.rootTemplateURL())
        return XCTemplateFolderMapper().map(folder)
    }

    public func templateFolder(for namespace: XCTemplateNamespace) throws -> XCTemplateFolder {
        let folder = try fileManager.templateFolder(at: url(for: namespace))
        return XCTemplateFolderMapper().map(folder)
    }

    public func rootTemplateFolderURL() -> URL {
        urlProvider.rootTemplateURL()
    }

    // MARK: - Private

    private func url(for namespace: XCTemplateNamespace) -> URL {
        urlProvider.url(for: namespace)
    }
}
