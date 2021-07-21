
import Foundation

public class XCSnippetLibrary {

    private let fileManager: FileManager
    private let snippetFileManager: XCSnippetFileManager
    private let downloader: XCSnippetsDownloader
    private let urlProvider: XCSnippetFolderURLProviding

    // MARK: - Life Cycle

    public convenience init() {
        let fileManager = FileManager.default
        let snippetFileManager = XCSnippetFileManager(fileManager: fileManager)
        self.init(
            fileManager: fileManager,
            snippetFileManager: snippetFileManager,
            downloader: XCSnippetsDownloader(
                fileManager: fileManager,
                snippetFileManager: snippetFileManager,
                strategyFactory: XCSnippetDownloadingStrategyFactory(fileManager: fileManager)
            ),
            urlProvider: NativeNamespaceFolderURLProvider()
        )
    }

    internal init(fileManager: FileManager,
                  snippetFileManager: XCSnippetFileManager,
                  downloader: XCSnippetsDownloader,
                  urlProvider: XCSnippetFolderURLProviding) {
        self.fileManager = fileManager
        self.snippetFileManager = snippetFileManager
        self.downloader = downloader
        self.urlProvider = urlProvider
    }

    // MARK: - Public

    public func installSnippets(for namespace: XCSnippetNamespace,
                                from source: XCSnippetSource) throws {
        let destination = urlProvider.rootSnippetFolderURL()
        try? fileManager.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
        try downloader.downloadSnippets(
            at: destination,
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
        }
        .sorted {
            $0.name < $1.name
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
