
import Foundation

public class XCSnippetLibrary {

    private let snippetFileManager: XCSnippetFileManager
    private let downloader: XCSnippetsDownloader
    private let urlProvider: XCSnippetFolderURLProviding

    // MARK: - Life Cycle

    public convenience init() {
        let snippetFileManager = XCSnippetFileManager(fileManager: .default)
        self.init(
            snippetFileManager: snippetFileManager,
            downloader: XCSnippetsDownloader(
                fileManager: .default,
                snippetFileManager: snippetFileManager,
                strategyFactory: XCSnippetDownloadingStrategyFactory(fileManager: .default)
            ),
            urlProvider: NativeNamespaceFolderURLProvider()
        )
    }

    internal init(snippetFileManager: XCSnippetFileManager,
                  downloader: XCSnippetsDownloader,
                  urlProvider: XCSnippetFolderURLProviding) {
        self.snippetFileManager = snippetFileManager
        self.downloader = downloader
        self.urlProvider = urlProvider
    }

    // MARK: - Public

    public func installSnippets(for namespace: XCSnippetNamespace,
                                from source: XCSnippetSource) throws {
        try downloader.downloadSnippets(
            at: urlProvider.rootSnippetFolderURL(),
            from: source,
            namespace: namespace
        )
    }

    public func removeSnippets(for namespace: XCSnippetNamespace) throws {
        try snippetFileManager.removeSnippets(
            with: SnippetNamespaceToSnippetFileTagMapper().map(namespace),
            at: urlProvider.rootSnippetFolderURL()
        )
    }

    public func snippetList(for namespace: XCSnippetNamespace) throws -> XCSnippetList {
        let mapper = SnippetFileToSnippetMapper()
        return XCSnippetList(snippets: try snippetFileManager.snippets(
            at: urlProvider.rootSnippetFolderURL(),
            with: SnippetNamespaceToSnippetFileTagMapper().map(namespace)
        ).map {
            mapper.map($0)
        })
    }

    public func snippetNamespaces() throws -> [XCSnippetNamespace] {
        let mapper = SnippetFileTagToSnippetNamespaceMapper()
        return try snippetFileManager.snippetTags(at: urlProvider.rootSnippetFolderURL()).map {
            mapper.map($0)
        }
    }

    public func snippetFolderURL() -> URL {
        urlProvider.rootSnippetFolderURL()
    }
}
