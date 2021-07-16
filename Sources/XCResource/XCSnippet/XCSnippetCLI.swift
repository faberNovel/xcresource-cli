
import Foundation

public class XCSnippetCLI {

    private let library = XCSnippetLibrary()

    // MARK: - Life Cycle

    public init() {}

    // MARK: - Public

    public func downloadSnippets(for namespace: XCSnippetNamespace,
                                 from source: XCSnippetSource) throws {
        try library.installSnippets(for: namespace, from: source)
    }

    public func removeSnippets(for namespace: XCSnippetNamespace) throws {
        try library.removeSnippets(for: namespace)
    }

    public func snippetList(for namespace: XCSnippetNamespace) throws -> XCSnippetList {
        try library.snippetList(for: namespace)
    }

    public func snippetNamespaces() throws -> [XCSnippetNamespace] {
        try library.snippetNamespaces()
    }

    public func openSnippetFolder() throws {
        try Shell().execute(.open(path: library.snippetFolderURL().path))
    }
}
